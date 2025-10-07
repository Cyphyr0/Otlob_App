import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/tawseya_provider.dart';
import '../widgets/tawseya_results_display.dart';
import '../widgets/tawseya_voting_card.dart';

class TawseyaScreen extends ConsumerStatefulWidget {
  const TawseyaScreen({super.key});

  @override
  ConsumerState<TawseyaScreen> createState() => _TawseyaScreenState();
}

class _TawseyaScreenState extends ConsumerState<TawseyaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tawseyaState = ref.watch(tawseyaProvider);
    final currentPeriod = ref.watch(currentVotingPeriodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تصويت',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFDC2626),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Voting Period Info
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFDC2626),
                child: Column(
                  children: [
                    Text(
                      currentPeriod?.displayName ?? 'Loading...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tawseyaState.maybeWhen(
                        data: (state) => state.canVote
                            ? 'يمكنك التصويت مرة واحدة هذا الشهر'
                            : state.hasVoted
                            ? 'لقد قمت بالتصويت هذا الشهر'
                            : state.votingPeriodEnded
                            ? 'انتهت فترة التصويت'
                            : 'جاري التحميل...',
                        orElse: () => 'جاري التحميل...',
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFDC2626),
                  labelColor: const Color(0xFFDC2626),
                  unselectedLabelColor: Colors.grey[600],
                  tabs: const [
                    Tab(text: 'التصويت', icon: Icon(Icons.how_to_vote)),
                    Tab(text: 'النتائج', icon: Icon(Icons.leaderboard)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Voting Tab
          tawseyaState.when(
            data: (state) => _buildVotingTab(state),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل بيانات التصويت',
                    style: TextStyle(color: Colors.red[300], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(tawseyaProvider.notifier).refreshVotingData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),

          // Results Tab
          const TawseyaResultsDisplay(),
        ],
      ),

      // Refresh button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(tawseyaProvider.notifier).refreshVotingData();
        },
        backgroundColor: const Color(0xFFDC2626),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildVotingTab(TawseyaState state) {
    if (state.tawseyaItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد عناصر تصويت متاحة',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tawseyaProvider.notifier).refreshVotingData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: state.tawseyaItems.length,
        itemBuilder: (context, index) {
          final item = state.tawseyaItems[index];
          return TawseyaVotingCard(
            tawseyaItem: item,
            onVote: () {
              ref.read(tawseyaProvider.notifier).refreshVotingData();
            },
          );
        },
      ),
    );
  }
}
