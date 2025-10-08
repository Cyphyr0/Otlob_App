import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/otlob_comprehensive_design_system.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({
    required this.onNext, super.key,
  });
  final VoidCallback onNext;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
  }
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation (bouncing entrance)
    _logoController = AnimationController(
      duration: OtlobAnimationSystem.durationSlow,
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_logoController);

    // Content fade-in animation
    _contentController = AnimationController(
      duration: OtlobAnimationSystem.durationNormal,
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: OtlobAnimationSystem.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(OtlobAnimationSystem.durationFast, () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      height: double.infinity,
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: OtlobSpacingSystem.allLg,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _logoController,
                _contentController
              ]),
              builder: (context, child) => Opacity(
                opacity: _contentFadeAnimation.value,
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: ShadButton.outline(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'تخطي',
                          style: OtlobTypographySystem.labelMd.copyWith(
                            color: OtlobColorSystem.nileBlue,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: OtlobSpacingSystem.lg),

                    // Main content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          // Egyptian cultural elements
                          _buildCulturalDecorations(),

                          SizedBox(height: OtlobSpacingSystem.lg),

                          // Otlob Logo with animation
                          ScaleTransition(
                            scale: _logoScaleAnimation,
                            child: Container(
                              padding: OtlobSpacingSystem.allXl,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: OtlobComponentSystem.shadowLg,
                              ),
                              child: Text(
                                'أطلب',
                                style: OtlobTypographySystem.logoFont(
                                  size: LogoSize.hero,
                                  color: OtlobColorSystem.pharaohRed,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: OtlobSpacingSystem.lg),

                          // Welcome text in Arabic and English
                          Text(
                            'مرحباً بك في أطلب',
                            style: OtlobTypographySystem.displayMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: OtlobSpacingSystem.md),

                          Text(
                            'Welcome to Otlob',
                            style: OtlobTypographySystem.h3.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: OtlobSpacingSystem.md),

                          Padding(
                            padding: OtlobSpacingSystem.horizontalMd,
                            child: Text(
                              'اكتشف أفضل المطاعم في مصر مع توصيات مجتمع أطلب الفريدة',
                              style: OtlobTypographySystem.bodyLgArabic.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: OtlobSpacingSystem.sm),

                              Padding(
                                padding: OtlobSpacingSystem.horizontalMd,
                                child: Text(
                                  'Discover Egypt\'s best restaurants with Otlob\'s unique community recommendations',
                                  style: OtlobTypographySystem.bodyLg.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.lg),

                    // Next button
                    PrimaryButton(
                      text: 'ابدأ الرحلة',
                      onPressed: widget.onNext,
                    ),

                    SizedBox(height: OtlobSpacingSystem.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildCulturalDecorations() => DecoratedBox(
      // Egyptian cultural background pattern using gradients
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCulturalIcon(Icons.local_dining, 'مطبخ مصري'),
          SizedBox(width: OtlobSpacingSystem.lg),
          _buildCulturalIcon(Icons.diamond, 'توصية'),
          SizedBox(width: OtlobSpacingSystem.lg),
          _buildCulturalIcon(Icons.people, 'مجتمع'),
        ],
      ),
    );

  Widget _buildCulturalIcon(IconData icon, String label) => Column(
      children: [
        Container(
          padding: OtlobSpacingSystem.allMd,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: OtlobComponentSystem.radiusFull,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: OtlobComponentSystem.iconSizeLg,
          ),
        ),
        SizedBox(height: OtlobSpacingSystem.xs),
        Text(
          label,
          style: OtlobTypographySystem.labelSm.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
}
