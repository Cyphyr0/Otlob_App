import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/otlob_comprehensive_design_system.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';

class AuthOptionsScreen extends StatefulWidget {

  const AuthOptionsScreen({
    required this.onNext, required this.onAuthMethodSelected, super.key,
  });
  final VoidCallback onNext;
  final Function(String) onAuthMethodSelected;

  @override
  State<AuthOptionsScreen> createState() => _AuthOptionsScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<Function(String p1)>.has('onAuthMethodSelected', onAuthMethodSelected));
  }
}

class _AuthOptionsScreenState extends State<AuthOptionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedAuthMethod;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: OtlobAnimationSystem.durationNormal,
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                      // Icon
                      Container(
                        padding: OtlobSpacingSystem.allXl,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: OtlobComponentSystem.shadowLg,
                        ),
                        child: Icon(
                          Icons.person_add,
                          size: 48.sp,
                          color: OtlobColorSystem.egyptianSunset,
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Title
                      Text(
                        'كيف تريد التسجيل؟',
                        style: OtlobTypographySystem.displayMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.md),

                      Text(
                        'How would you like to sign up?',
                        style: OtlobTypographySystem.h3.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.lg),

                      // Description
                      Text(
                        'اختر طريقة التسجيل المناسبة لك للحصول على تجربة مخصصة',
                        style: OtlobTypographySystem.bodyLgArabic.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.sm),

                      Text(
                        'Choose your preferred sign-up method for a personalized experience',
                        style: OtlobTypographySystem.bodyLg.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Auth options
                      Column(
                        children: [
                          _buildAuthOption(
                            icon: Icons.phone_android,
                            title: 'رقم الهاتف',
                            subtitle: 'تسجيل بالهاتف المصري',
                            color: OtlobColorSystem.success,
                            isSelected: _selectedAuthMethod == 'phone',
                            onTap: () => _selectAuthMethod('phone'),
                          ),

                          SizedBox(height: OtlobSpacingSystem.md),

                          _buildAuthOption(
                            icon: Icons.email,
                            title: 'البريد الإلكتروني',
                            subtitle: 'تسجيل بالإيميل',
                            color: OtlobColorSystem.info,
                            isSelected: _selectedAuthMethod == 'email',
                            onTap: () => _selectAuthMethod('email'),
                          ),

                          SizedBox(height: OtlobSpacingSystem.md),

                          _buildAuthOption(
                            icon: Icons.g_mobiledata,
                            title: 'جوجل',
                            subtitle: 'تسجيل بحساب جوجل',
                            color: Colors.blue,
                            isSelected: _selectedAuthMethod == 'google',
                            onTap: () => _selectAuthMethod('google'),
                          ),

                          SizedBox(height: OtlobSpacingSystem.md),

                          _buildAuthOption(
                            icon: Icons.facebook,
                            title: 'فيسبوك',
                            subtitle: 'تسجيل بحساب فيسبوك',
                            color: Colors.blue.shade700,
                            isSelected: _selectedAuthMethod == 'facebook',
                            onTap: () => _selectAuthMethod('facebook'),
                          ),
                        ],
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Terms and conditions
                      Container(
                        padding: OtlobSpacingSystem.allMd,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: OtlobComponentSystem.radiusMd,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: OtlobTypographySystem.bodySm.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              height: 1.4,
                            ),
                            children: const [
                              TextSpan(text: 'بالتسجيل، أنت توافق على '),
                              TextSpan(
                                text: 'شروط الخدمة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' و'),
                              TextSpan(
                                text: 'سياسة الخصوصية',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xxl),
                    ],
                  ),

                  // Action buttons
                  Column(
                    children: [
                      PrimaryButton(
                        text: _selectedAuthMethod == null ? 'تخطي التسجيل' : 'متابعة',
                        onPressed: () {
                          if (_selectedAuthMethod != null) {
                            widget.onAuthMethodSelected(_selectedAuthMethod!);
                          }
                          widget.onNext();
                        },
                      ),

                      if (_selectedAuthMethod != null)
                        SizedBox(height: OtlobSpacingSystem.sm),

                      if (_selectedAuthMethod != null)
                        SecondaryButton(
                          text: 'لدي حساب بالفعل',
                          onPressed: () {
                            // TODO: Navigate to login screen
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

  Widget _buildAuthOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: OtlobAnimationSystem.durationFast,
        padding: OtlobSpacingSystem.allMd,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: OtlobComponentSystem.radiusLg,
          border: Border.all(
            color: isSelected
                ? color
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: OtlobSpacingSystem.allMd,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                borderRadius: OtlobComponentSystem.radiusMd,
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: isSelected ? color : Colors.white,
              ),
            ),

            SizedBox(width: OtlobSpacingSystem.md),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: OtlobTypographySystem.bodyLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: OtlobSpacingSystem.xs),
                  Text(
                    subtitle,
                    style: OtlobTypographySystem.bodySm.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                padding: OtlobSpacingSystem.allXs,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: OtlobComponentSystem.iconSizeSm,
                ),
              ),
          ],
        ),
      ),
    );

  void _selectAuthMethod(String method) {
    setState(() {
      _selectedAuthMethod = method;
    });
  }
}