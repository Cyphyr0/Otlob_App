import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/otlob_comprehensive_design_system.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';

class TawseyaIntroScreen extends StatefulWidget {

  const TawseyaIntroScreen({
    required this.onNext, required this.onTawseyaEnabled, super.key,
  });
  final VoidCallback onNext;
  final Function(bool) onTawseyaEnabled;

  @override
  State<TawseyaIntroScreen> createState() => _TawseyaIntroScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<Function(bool p1)>.has('onTawseyaEnabled', onTawseyaEnabled));
  }
}

class _TawseyaIntroScreenState extends State<TawseyaIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _tawseyaEnabled = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: OtlobAnimationSystem.durationSlow,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: OtlobAnimationSystem.durationExtraSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: OtlobAnimationSystem.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: OtlobAnimationSystem.easeOut,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_animationController);

    _animationController.forward();

    // Start pulsing animation for the diamond icon
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OtlobColorSystem.egyptianSunset,
            OtlobColorSystem.saharaGold,
            OtlobColorSystem.desertSand,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: OtlobSpacingSystem.allLg,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: SecondaryButton(
                      text: 'تخطي',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  const Spacer(),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated diamond icon
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _animationController,
                          _pulseController
                        ]),
                        builder: (context, child) => ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              padding: OtlobSpacingSystem.allXl,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: OtlobColorSystem.tawseya.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: OtlobColorSystem.tawseya.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) => Icon(
                                    Icons.diamond,
                                    size: 64.sp,
                                    color: OtlobColorSystem.tawseya,
                                  ),
                              ),
                            ),
                          ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Title
                      Text(
                        'اكتشف جواهر أطلب المخفية',
                        style: OtlobTypographySystem.displayMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.md),

                      Text(
                        'Discover Otlob\'s Hidden Gems',
                        style: OtlobTypographySystem.h3.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.lg),

                      // Description
                      Container(
                        padding: OtlobSpacingSystem.allMd,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: OtlobComponentSystem.radiusLg,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'نظام التوصية الفريد من أطلب يساعدك في اكتشاف أفضل المطاعم المخفية في مصر من خلال تصويت المجتمع',
                              style: OtlobTypographySystem.bodyLgArabic.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: OtlobSpacingSystem.md),

                            Text(
                              'Otlob\'s unique recommendation system helps you discover Egypt\'s best hidden restaurants through community voting',
                              style: OtlobTypographySystem.bodyLg.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Features
                      _buildFeatureList(),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Monthly theme preview
                      Container(
                        padding: OtlobSpacingSystem.allMd,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              OtlobColorSystem.tawseya.withOpacity(0.2),
                              OtlobColorSystem.tawseya.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: OtlobComponentSystem.radiusLg,
                          border: Border.all(
                            color: OtlobColorSystem.tawseya.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: OtlobColorSystem.tawseya,
                                  size: OtlobComponentSystem.iconSizeMd,
                                ),
                                SizedBox(width: OtlobSpacingSystem.sm),
                                Text(
                                  'موضوع الشهر الحالي',
                                  style: OtlobTypographySystem.bodyLg.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: OtlobSpacingSystem.md),

                            Container(
                              padding: OtlobSpacingSystem.allMd,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: OtlobComponentSystem.radiusMd,
                              ),
                              child: Text(
                                'أفضل المطاعم للعائلات في رمضان',
                                style: OtlobTypographySystem.bodyLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: OtlobSpacingSystem.sm),

                            Text(
                              'Best family restaurants for Ramadan',
                              style: OtlobTypographySystem.bodyMd.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xxl),
                    ],
                  ),

                  // Action buttons
                  Column(
                    children: [
                      // Enable/Disable Tawseya toggle
                      Container(
                        padding: OtlobSpacingSystem.allMd,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: OtlobComponentSystem.radiusLg,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تفعيل نظام التوصية',
                                  style: OtlobTypographySystem.bodyLg.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Enable recommendation system',
                                  style: OtlobTypographySystem.bodySm.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _tawseyaEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _tawseyaEnabled = value;
                                });
                              },
                              activeThumbColor: OtlobColorSystem.tawseya,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.md),

                      PrimaryButton(
                        text: 'ابدأ رحلة التوصية',
                        onPressed: () {
                          widget.onTawseyaEnabled(_tawseyaEnabled);
                          widget.onNext();
                        },
                      ),

                      SizedBox(height: OtlobSpacingSystem.sm),

                      SecondaryButton(
                        text: 'تخطي هذه الميزة',
                        onPressed: () {
                          widget.onTawseyaEnabled(false);
                          widget.onNext();
                        },
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildFeatureList() {
    final features = [
      {
        'icon': Icons.people,
        'title': 'تصويت المجتمع',
        'subtitle': 'Community Voting',
      },
      {
        'icon': Icons.calendar_month,
        'title': 'مواضيع شهرية',
        'subtitle': 'Monthly Themes',
      },
      {
        'icon': Icons.local_activity,
        'title': 'جوائز خاصة',
        'subtitle': 'Special Rewards',
      },
      {
        'icon': Icons.visibility,
        'title': 'اكتشاف الجواهر المخفية',
        'subtitle': 'Hidden Gems Discovery',
      },
    ];

    return Column(
      children: features.map((feature) => Container(
          margin: OtlobSpacingSystem.verticalSm,
          padding: OtlobSpacingSystem.allMd,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: OtlobComponentSystem.radiusMd,
          ),
          child: Row(
            children: [
              Container(
                padding: OtlobSpacingSystem.allSm,
                decoration: BoxDecoration(
                  color: OtlobColorSystem.tawseya.withOpacity(0.2),
                  borderRadius: OtlobComponentSystem.radiusSm,
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: OtlobColorSystem.tawseya,
                  size: OtlobComponentSystem.iconSizeMd,
                ),
              ),

              SizedBox(width: OtlobSpacingSystem.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: OtlobTypographySystem.bodyMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      feature['subtitle'] as String,
                      style: OtlobTypographySystem.bodySm.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
    );
  }
}