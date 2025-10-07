import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../widgets/animated_dice_roll.dart';
import '../../domain/entities/surprise_me_result.dart';
import '../../domain/services/surprise_me_service.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../../user_preferences/domain/entities/user_preferences.dart';
import '../../../favorites/domain/entities/favorite.dart';
import '../../../tawseya/domain/entities/tawseya_item.dart';

class SurpriseMeScreen extends ConsumerStatefulWidget {
  const SurpriseMeScreen({
    super.key,
    required this.restaurants,
    this.userPreferences,
    this.userFavorites = const [],
    this.tawseyaItems = const [],
  });

  final List<Restaurant> restaurants;
  final UserPreferences? userPreferences;
  final List<Favorite> userFavorites;
  final List<TawseyaItem> tawseyaItems;

  @override
  ConsumerState<SurpriseMeScreen> createState() => _SurpriseMeScreenState();
}

class _SurpriseMeScreenState extends ConsumerState<SurpriseMeScreen> {
  bool _isRolling = false;
  SurpriseMeResult? _result;

  Future<void> _startSurprise() async {
    if (widget.restaurants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No restaurants available')),
      );
      return;
    }

    setState(() => _isRolling = true);

    try {
      final surpriseMeService = SurpriseMeService();
      final result = await surpriseMeService.generateSurprise(
        restaurants: widget.restaurants,
        userPreferences: widget.userPreferences,
        userFavorites: widget.userFavorites,
        tawseyaItems: widget.tawseyaItems,
        currentUserId: 'current_user', // TODO: Get from auth provider
      );

      setState(() => _result = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => _isRolling = false);
    }
  }

  void _onRollComplete() {
    setState(() => _isRolling = false);
  }

  void _goToRestaurant() {
    if (_result != null) {
      context.go('/restaurant/${_result!.restaurant.id}');
    }
  }

  void _tryAgain() {
    setState(() => _result = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surprise Me!',
          style: AppTypography.headlineMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.logoRed.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header text
              Text(
                'Let\'s find you the perfect restaurant!',
                style: AppTypography.headlineSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.xl),

              // Animation or result
              if (_result == null) ...[
                // Dice animation
                AnimatedDiceRoll(
                  onRollComplete: _onRollComplete,
                  restaurantName: '',
                  size: 200,
                ),

                SizedBox(height: AppSpacing.xl),

                // Start button
                if (!_isRolling)
                  PrimaryButton(
                    text: 'Roll the Dice!',
                    icon: Icons.casino,
                    onPressed: _startSurprise,
                  ),
              ] else ...[
                // Result display
                _buildResultCard(),

                SizedBox(height: AppSpacing.xl),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Try Again',
                        icon: Icons.refresh,
                        onPressed: _tryAgain,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        text: 'Go to Restaurant',
                        icon: Icons.arrow_forward,
                        onPressed: _goToRestaurant,
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: AppSpacing.xl),

              // User preferences hint
              if (widget.userPreferences == null || !widget.userPreferences!.hasPreferences)
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.logoRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.logoRed.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.logoRed,
                        size: 24,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Set up your food preferences in your profile for better recommendations!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.logoRed,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_result == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Restaurant image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant,
              size: 40,
              color: AppColors.gray,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Restaurant name
          Text(
            _result!.restaurant.name,
            style: AppTypography.headlineMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.sm),

          // Cuisine and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _result!.restaurant.cuisine,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Text(
                ' ${_result!.restaurant.rating.toStringAsFixed(1)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Surprise message
          Text(
            _result!.message,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.logoRed,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.md),

          // Reasoning
          Text(
            _result!.reasoning,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.md),

          // Confidence indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _getConfidenceColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getConfidenceColor(),
              ),
            ),
            child: Text(
              _result!.confidenceText,
              style: AppTypography.bodySmall.copyWith(
                color: _getConfidenceColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor() {
    if (_result == null) return AppColors.gray;

    final confidence = _result!.confidence;
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.blue;
    if (confidence >= 0.4) return Colors.orange;
    return Colors.grey;
  }
}