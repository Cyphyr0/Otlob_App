import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/service_locator.dart';
import '../../data/repositories/firebase_tawseya_repository.dart';
import '../../domain/entities/tawseya_item.dart';
import '../../domain/entities/vote.dart';
import '../../domain/entities/voting_period.dart';
import '../../domain/repositories/tawseya_repository.dart';
import '../../domain/usecases/cast_vote.dart';

class TawseyaValidationException implements Exception {
  final String message;
  const TawseyaValidationException(this.message);

  @override
  String toString() => message;
}

class TawseyaStateNotifier extends AsyncNotifier<TawseyaState> {
  @override
  Future<TawseyaState> build() async {
    await _initializeData();
    return _getInitialState();
  }

  Future<void> _initializeData() async {
    try {
      final repository = ref.read(tawseyaRepositoryProvider);
      final currentPeriod = await repository.getCurrentVotingPeriod();
      final activeItems = await repository.getActiveTawseyaItems();

      state = AsyncValue.data(
        TawseyaState(
          currentVotingPeriod: currentPeriod,
          tawseyaItems: activeItems,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  TawseyaState _getInitialState() {
    return TawseyaState(
      currentVotingPeriod: null,
      tawseyaItems: [],
      isLoading: true,
    );
  }

  Future<void> castVote(TawseyaItem item, {String? comment}) async {
    if (state.value == null) return;

    // Validate user is logged in
    final currentUser = await _getCurrentUser();
    if (currentUser == null) {
      state = AsyncValue.error(
        const TawseyaValidationException('يجب تسجيل الدخول للتصويت'),
        StackTrace.current,
      );
      return;
    }

    // Validate voting period is active
    final currentPeriod = state.value!.currentVotingPeriod;
    if (currentPeriod == null) {
      state = AsyncValue.error(
        const TawseyaValidationException('لا توجد فترة تصويت نشطة حالياً'),
        StackTrace.current,
      );
      return;
    }

    if (!currentPeriod.isCurrentPeriod) {
      state = AsyncValue.error(
        TawseyaValidationException(
          'فترة التصويت ${currentPeriod.displayName} غير نشطة',
        ),
        StackTrace.current,
      );
      return;
    }

    // Validate tawseya item is available for voting
    if (!item.canVote) {
      state = AsyncValue.error(
        TawseyaValidationException(
          item.isExpired
              ? 'انتهت صلاحية هذا العنصر للتصويت'
              : 'هذا العنصر غير متاح للتصويت حالياً',
        ),
        StackTrace.current,
      );
      return;
    }

    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    try {
      final repository = ref.read(tawseyaRepositoryProvider);

      final castVoteUseCase = CastVote(repository);
      await castVoteUseCase(
        userId: currentUser,
        tawseyaItem: item,
        votingPeriod: currentPeriod,
        comment: comment,
      );

      // Refresh data after voting
      await _refreshData();
    } catch (e, st) {
      String errorMessage = 'فشل في تسجيل التصويت';

      if (e is VoteAlreadyExistsException) {
        errorMessage = 'لقد قمت بالتصويت بالفعل هذا الشهر';
      } else if (e is TawseyaValidationException) {
        errorMessage = e.message;
      }

      state = AsyncValue.error(TawseyaValidationException(errorMessage), st);
    }
  }

  Future<void> refreshVotingData() async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));
    await _refreshData();
  }

  Future<void> _refreshData() async {
    try {
      final repository = ref.read(tawseyaRepositoryProvider);
      final currentPeriod = await repository.getCurrentVotingPeriod();
      final activeItems = await repository.getActiveTawseyaItems();

      state = AsyncValue.data(
        TawseyaState(
          currentVotingPeriod: currentPeriod,
          tawseyaItems: activeItems,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String?> _getCurrentUser() async {
    // This would typically come from auth provider
    // For now, return a placeholder - this should be integrated with auth
    return 'current_user_id'; // TODO: Get from auth provider
  }
}

class TawseyaState {
  final VotingPeriod? currentVotingPeriod;
  final List<TawseyaItem> tawseyaItems;
  final bool isLoading;
  final Vote? userCurrentVote;

  const TawseyaState({
    required this.currentVotingPeriod,
    required this.tawseyaItems,
    required this.isLoading,
    this.userCurrentVote,
  });

  TawseyaState copyWith({
    VotingPeriod? currentVotingPeriod,
    List<TawseyaItem>? tawseyaItems,
    bool? isLoading,
    Vote? userCurrentVote,
  }) {
    return TawseyaState(
      currentVotingPeriod: currentVotingPeriod ?? this.currentVotingPeriod,
      tawseyaItems: tawseyaItems ?? this.tawseyaItems,
      isLoading: isLoading ?? this.isLoading,
      userCurrentVote: userCurrentVote ?? this.userCurrentVote,
    );
  }

  bool get canVote =>
      currentVotingPeriod?.isCurrentPeriod == true && userCurrentVote == null;
  bool get hasVoted => userCurrentVote != null;
  bool get votingPeriodEnded => currentVotingPeriod?.hasEnded == true;
}

// Providers
final tawseyaProvider =
    AsyncNotifierProvider<TawseyaStateNotifier, TawseyaState>(
      TawseyaStateNotifier.new,
    );

final tawseyaRepositoryProvider = Provider<TawseyaRepository>((ref) {
  return getIt<FirebaseTawseyaRepository>();
});

// Convenience providers for specific state slices
final tawseyaItemsProvider = Provider<List<TawseyaItem>>((ref) {
  return ref
      .watch(tawseyaProvider)
      .maybeWhen(data: (state) => state.tawseyaItems, orElse: () => []);
});

final currentVotingPeriodProvider = Provider<VotingPeriod?>((ref) {
  return ref
      .watch(tawseyaProvider)
      .maybeWhen(
        data: (state) => state.currentVotingPeriod,
        orElse: () => null,
      );
});

final canVoteProvider = Provider<bool>((ref) {
  return ref
      .watch(tawseyaProvider)
      .maybeWhen(data: (state) => state.canVote, orElse: () => false);
});

final tawseyaLoadingProvider = Provider<bool>((ref) {
  return ref
      .watch(tawseyaProvider)
      .maybeWhen(
        data: (state) => state.isLoading,
        loading: () => true,
        orElse: () => false,
      );
});
