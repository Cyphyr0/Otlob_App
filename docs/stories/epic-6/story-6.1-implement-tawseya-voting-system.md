# Story: Implement Tawseya Voting System
**Epic:** Epic 6 - Unique Features (Differentiation)
**Story ID:** epic-6.story-6.1
**Priority:** P0 - Core Differentiator Feature
**Story Points:** 8 (Complex, High Risk)
**Status:** 📝 Draft - Ready for SM Refinement

---

## Story Overview

**As a** food enthusiast exploring authentic Egyptian cuisine
**I want to** vote for my favorite restaurants using the Tawseya system
**So that I** I can contribute to a community-driven recommendation ecosystem that highlights genuine local gems

## Business Context

Tawseya is Otlob's unique differentiator - a monthly voting system where each user gets exactly one vote per month to award to any restaurant. This creates authentic, community-driven curation rather than algorithm-driven or advertising-based recommendations.

**Business Value:**
- Differentiates Otlob from generic food delivery apps
- Builds community engagement and loyalty
- Creates data for "Local Heroes" curated carousel
- Provides genuine social proof vs. fake reviews

## Acceptance Criteria

### Functional Requirements
- [ ] Each authenticated user gets exactly 1 Tawseya vote per month
- [ ] User can award Tawseya to any restaurant (including multiple votes to same restaurant)
- [ ] Tawseya votes reset monthly on calendar date (Egypt time zone)
- [ ] Restaurant profile prominently displays current Tawseya count
- [ ] "Award Tawseya" button visible on restaurant details screen
- [ ] Vote confirmation dialog with monthly limit explanation
- [ ] Vote success feedback with restaurant name and remaining time until reset
- [ ] Prevent multiple votes in same month (client-side + server-side validation)
- [ ] Vote history accessible in user profile

### Non-Functional Requirements
- [ ] **Performance:** Vote submission completes within 2 seconds
- [ ] **Reliability:** Vote persistence survives app restart
- [ ] **Security:** Server-side validation prevents vote manipulation
- [ ] **Offline:** Votes queue when offline, sync when online
- [ ] **Accessibility:** Voice-over support for vote buttons

## Technical Design

### Domain Model Updates

#### Entity: TawseyaVote
```dart
@freezed
class TawseyaVote with _$TawseyaVote {
  const factory TawseyaVote({
    required String id,
    required String userId,
    required String restaurantId,
    required DateTime votedAt,
    required int month,  // YYYYMM format
    required int year,
  }) = _TawseyaVote;

  // Helper methods
  bool isForCurrentMonth() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 2)); // Egypt time
    return year == now.year && month == (now.year * 100 + now.month);
  }
}
```

#### Entity: User (Add Tawseya Info)
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    // ... existing fields ...
    required TawseyaEligibility tawseyaEligibility,
  }) = _User;
}

@freezed
class TawseyaEligibility with _$TawseyaEligibility {
  const factory TawseyaEligibility({
    required bool hasVotedThisMonth,
    required DateTime? lastVoteDate,
    required DateTime nextResetDate,
    required int remainingDays,
  }) = _TawseyaEligibility;
}
```

### Data Layer Design

#### New Repository Interface
```dart
abstract class TawseyaRepository {
  Future<Either<Failure, TawseyaEligibility>> getEligibility(String userId);
  Future<Either<Failure, Unit>> castVote(CastVoteRequest request);
  Future<Either<Failure, List<TawseyaVote>>> getUserVoteHistory(String userId);
  Future<Either<Failure, int>> getRestaurantTawseyaCount(String restaurantId);
}
```

#### Request/Response Models
```dart
@freezed
class CastVoteRequest with _$CastVoteRequest {
  const factory CastVoteRequest({
    required String userId,
    required String restaurantId,
    required String restaurantName,  // For confirmation message
  }) = _CastVoteRequest;
}

@freezed
class CastVoteResponse with _$CastVoteResponse {
  const factory CastVoteResponse({
    required bool success,
    required String message,
    required TawseyaEligibility updatedEligibility,
    required int newRestaurantCount,
  }) = _CastVoteResponse;
}
```

### Data Sources

#### Remote Data Source
```dart
abstract class TawseyaRemoteDataSource {
  Future<TawseyaEligibilityModel> getEligibility(String userId);
  Future<CastVoteResponseModel> castVote(CastVoteRequestModel request);
  Future<List<TawseyaVoteModel>> getUserVoteHistory(String userId);
  Future<int> getRestaurantTawseyaCount(String restaurantId);
}

class TawseyaRemoteDataSourceImpl implements TawseyaRemoteDataSource {
  final Dio dio;
  TawseyaRemoteDataSourceImpl(this.dio);

  @override
  Future<TawseyaEligibilityModel> getEligibility(String userId) async {
    final response = await dio.get('/users/$userId/tawseya-eligibility');
    return TawseyaEligibilityModel.fromJson(response.data);
  }

  // Implement other methods...
}
```

#### Local Data Source (Cache)
```dart
abstract class TawseyaLocalDataSource {
  Future<TawseyaEligibilityModel?> getCachedEligibility(String userId);
  Future<void> cacheEligibility(TawseyaEligibilityModel eligibility);
  Future<void> clearEligibilityCache(String userId);
}
```

### Presentation Layer Design

#### Providers (Riverpod)

**Tawseya Eligibility Provider:**
```dart
@riverpod
class TawseyaEligibility extends _$TawseyaEligibility {
  @override
  Future<TawseyaEligibility> build(String userId) async {
    final repository = ref.read(tawseyaRepositoryProvider);
    return repository.getEligibility(userId).fold(
      (failure) => throw failure,
      (eligibility) => eligibility,
    );
  }

  Future<void> castVote(String restaurantId, String restaurantName) async {
    final repository = ref.read(tawseyaRepositoryProvider);
    final request = CastVoteRequest(
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );

    final result = await repository.castVote(request);
    result.fold(
      (failure) => throw failure,
      (response) {
        // Update local state
        state = AsyncValue.data(response.updatedEligibility);
        // Show success message
      },
    );
  }
}
```

**Restaurant Tawseya Count Provider:**
```dart
@riverpod
Future<int> restaurantTawseyaCount(RestaurantTawseyaCountRef ref, String restaurantId) async {
  final repository = ref.read(tawseyaRepositoryProvider);
  return repository.getRestaurantTawseyaCount(restaurantId).fold(
    (failure) => throw failure,
    (count) => count,
  );
}
```

#### UI Components

**Tawseya Vote Button:**
```dart
class TawseyaVoteButton extends ConsumerWidget {
  const TawseyaVoteButton({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  final String restaurantId;
  final String restaurantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibilityAsync = ref.watch(tawseyaEligibilityProvider(ref.read(userIdProvider)));

    return eligibilityAsync.when(
      data: (eligibility) => _buildButton(context, ref, eligibility),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildButton(BuildContext context, WidgetRef ref, TawseyaEligibility eligibility) {
    if (eligibility.hasVotedThisMonth) {
      return _buildAlreadyVotedButton(context, eligibility);
    } else {
      return _buildVoteButton(context, ref);
    }
  }

  Widget _buildVoteButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => _showVoteConfirmation(context, ref),
      icon: const Icon(Icons.stars),
      label: const Text('Award Tawseya'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAlreadyVotedButton(BuildContext context, TawseyaEligibility eligibility) {
    return OutlinedButton.icon(
      onPressed: null, // Disabled
      icon: const Icon(Icons.check_circle, color: AppColors.success),
      label: Text('Voted (${eligibility.remainingDays}d until reset)'),
    );
  }

  void _showVoteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => TawseyaVoteDialog(
        restaurantName: restaurantName,
        onConfirm: () => _castVote(context, ref),
      ),
    );
  }

  Future<void> _castVote(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(tawseyaEligibilityProvider(ref.read(userIdProvider)).notifier)
          .castVote(restaurantId, restaurantName);
    } catch (e) {
      // Handle error
    }
  }
}
```

**Tawseya Vote Dialog:**
```dart
class TawseyaVoteDialog extends StatelessWidget {
  const TawseyaVoteDialog({
    super.key,
    required this.restaurantName,
    required this.onConfirm,
  });

  final String restaurantName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Award Tawseya Vote'),
      content: Text(
        'Are you sure you want to award your monthly Tawseya vote to $restaurantName? '
        'You can only vote once per month.'
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Award Vote'),
        ),
      ],
    );
  }
}
```

**Tawseya Count Display:**
```dart
class TawseyaCountBadge extends ConsumerWidget {
  const TawseyaCountBadge({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(restaurantTawseyaCountProvider(restaurantId));

    return countAsync.when(
      data: (count) => _buildBadge(count),
      loading: () => const SizedBox(
        width: 60,
        height: 24,
        child: LinearProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, size: 16, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Error Handling Strategy

### Domain Failures
```dart
class TawseyaFailure extends Failure {
  const TawseyaFailure(super.message, {super.statusCode});

  static const TawseyaFailure alreadyVotedThisMonth = TawseyaFailure(
    'You have already cast your Tawseya vote this month',
  );

  static const TawseyaFailure voteLimitExceeded = TawseyaFailure(
    'Monthly vote limit exceeded',
  );

  static const TawseyaFailure invalidRestaurant = TawseyaFailure(
    'Invalid restaurant ID',
  );
}
```

### UI Error States
- **Already voted:** Show countdown until reset
- **Network error:** Show retry option
- **Server error:** Show contact support
- **Rate limiting:** Show cooldown timer

## Testing Strategy

### Unit Tests
- [ ] TawseyaRepositoryImpl casts vote correctly
- [ ] TawseyaEligibility calculates remaining days accurately
- [ ] Vote validation prevents multiple votes per month
- [ ] Cache invalidation works on vote cast

### Widget Tests
- [ ] TawseyaVoteButton shows correct state (available/voted/disabled)
- [ ] VoteDialog displays restaurant name and confirmation text
- [ ] TawseyaCountBadge displays correct count with loading/error states
- [ ] Vote button triggers correct provider methods

### Integration Tests
- [ ] Complete vote casting flow (UI → Repository → API)
- [ ] Offline vote queueing and sync
- [ ] Eligibility refresh after vote cast
- [ ] Restaurant count updates across screens

## Implementation Plan

### Phase 1: Core Domain & Data Layer
1. Create TawseyaVote and User entities with TawseyaEligibility
2. Implement TawseyaRepository interface and concrete implementation
3. Add TawseyaRemoteDataSource with Firebase integration
4. Create local caching for eligibility data

### Phase 2: Presentation Layer
1. Create Tawseya-related Riverpod providers
2. Implement UI components (VoteButton, VoteDialog, CountBadge)
3. Add Tawseya vote button to restaurant detail screen
4. Integrate Tawseya count badge in restaurant cards and details

### Phase 3: Error Handling & Polish
1. Implement comprehensive error handling
2. Add loading states and success feedback
3. Create vote history screen in user profile
4. Add accessibility support (VoiceOver/TalkBack)

### Phase 4: Testing & Validation
1. Write comprehensive unit tests
2. Implement widget tests for UI components
3. Conduct integration testing of complete flow
4. Perform QA review with all test scenarios

## Dependencies & Prerequisites

### Backend Requirements
- [ ] Tawseya collection in Firestore with proper security rules
- [ ] Monthly vote reset mechanism
- [ ] Vote validation and duplicate prevention
- [ ] Real-time tawseya count updates

### Design Assets
- [ ] Tawseya vote icon (star burst design)
- [ ] Vote confirmation dialog mockups
- [ ] Already voted state styling
- [ ] Tawseya count badge design

### Frontend Prerequisites
- [ ] Restaurant detail screen implementation
- [ ] User authentication state management
- [ ] Toast/snackbar notification system
- [ ] Error handling UI components

## Risk Assessment

### High-Risk Items
1. **Vote Reset Logic:** Complex date calculations across time zones
2. **Race Conditions:** Multiple vote attempts before server validation
3. **Offline Handling:** Vote queueing and conflict resolution
4. **Real-time Updates:** Ensuring count consistency across screens

### Mitigation Strategies
1. **Server-side validation** for all vote operations
2. **Optimistic updates** with rollback on failure
3. **Queue-based offline sync** with conflict resolution
4. **Firebase real-time listeners** for live count updates

## Success Metrics

### Functional Success
- [ ] Users can cast exactly one vote per month
- [ ] Vote immediately updates restaurant tawseya count
- [ ] Vote persists across app restarts
- [ ] System prevents invalid votes (duplicate, non-existent restaurant)

### User Experience Success
- [ ] Vote casting takes <2 seconds end-to-end
- [ ] Clear feedback for all voting states
- [ ] Intuitive voting flow with helpful explanations
- [ ] Consistent tawseya count display across app

### Quality Success
- [ ] 90%+ test coverage for new functionality
- [ ] No crashes or errors in vote flow
- [ ] Passes accessibility audit
- [ ] All acceptance criteria validated

## Files to be Created/Modified

### New Files
```
lib/features/tawseya/
├── domain/
│   ├── entities/
│   │   ├── tawseya_vote.dart
│   │   └── tawseya_eligibility.dart
│   ├── repositories/
│   │   └── tawseya_repository.dart
│   └── use_cases/
│       └── cast_tawseya_vote.dart
├── data/
│   ├── models/
│   │   ├── tawseya_vote_model.dart
│   │   ├── tawseya_eligibility_model.dart
│   │   └── cast_vote_request_model.dart
│   ├── datasources/
│   │   ├── tawseya_remote_datasource.dart
│   │   └── tawseya_local_datasource.dart
│   └── repositories/
│       └── tawseya_repository_impl.dart
└── presentation/
    ├── providers/
    │   ├── tawseya_eligibility_provider.dart
    │   ├── restaurant_tawseya_count_provider.dart
    │   └── tawseya_vote_history_provider.dart
    ├── screens/
    │   └── tawseya_vote_history_screen.dart
    ├── widgets/
    │   ├── tawseya_vote_button.dart
    │   ├── tawseya_vote_dialog.dart
    │   └── tawseya_count_badge.dart
    └── pages/
        └── tawseya_vote_history_page.dart

lib/core/errors/tawseya_failures.dart
lib/core/services/tawseya_service.dart
```

### Modified Files
- `lib/features/auth/domain/entities/user.dart` (add TawseyaEligibility)
- `lib/features/home/presentation/screens/restaurant_detail_screen.dart` (add vote button)
- `lib/features/home/presentation/widgets/restaurant_card.dart` (add tawseya badge)
- `lib/core/routes/app_router.dart` (add tawseya routes)

---

**Story Owner:** Flutter Development Team (BMAD-METHOD)
**Estimated Effort:** 8 Story Points (3-4 days with testing)
**Acceptance Reviews:** QA Agent + Manual Testing
**Documentation:** Technical design reviewed by Architect Agent

**Ready for SM Refinement:** This story draft contains detailed implementation guidance but may need adjustment based on current codebase state and technical constraints.
