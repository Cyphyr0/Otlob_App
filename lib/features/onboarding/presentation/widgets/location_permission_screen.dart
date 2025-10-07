import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/otlob_comprehensive_design_system.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';

class LocationPermissionScreen extends StatefulWidget {

  const LocationPermissionScreen({
    required this.onNext, required this.onLocationSelected, super.key,
  });
  final VoidCallback onNext;
  final Function(String?) onLocationSelected;

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<Function(String? p1)>.has('onLocationSelected', onLocationSelected));
  }
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _hasPermission = false;
  String? _currentLocation;
  String? _errorMessage;

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
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        setState(() {
          _hasPermission = true;
        });
        await _getCurrentLocation();
      } else {
        setState(() {
          _hasPermission = false;
          _errorMessage = 'يجب السماح بمشاركة الموقع للحصول على أفضل تجربة';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في الوصول إلى الموقع';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates (simplified for demo)
      setState(() {
        _currentLocation = 'القاهرة, مصر'; // In real app, use geocoding
        _hasPermission = true;
      });

      widget.onLocationSelected(_currentLocation);
    } catch (e) {
      setState(() {
        _errorMessage = 'تعذر الحصول على الموقع الحالي';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      // Location icon with animation
                      AnimatedContainer(
                        duration: OtlobAnimationSystem.durationNormal,
                        padding: OtlobSpacingSystem.allXl,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: OtlobComponentSystem.shadowLg,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 48.w,
                                height: 48.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    OtlobColorSystem.egyptianSunset,
                                  ),
                                ),
                              )
                            : Icon(
                                _hasPermission ? Icons.location_on : Icons.location_off,
                                size: 48.sp,
                                color: OtlobColorSystem.egyptianSunset,
                              ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Title
                      Text(
                        'دعنا نحدد موقعك',
                        style: OtlobTypographySystem.displayMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.md),

                      Text(
                        'Let\'s find your location',
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
                        child: Text(
                          'نحتاج إلى معرفة موقعك لنقترح أفضل المطاعم القريبة منك ولضمان توصيل سريع وفعال',
                          style: OtlobTypographySystem.bodyLgArabic.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.sm),

                      Text(
                        'We need your location to suggest the best nearby restaurants and ensure fast, efficient delivery',
                        style: OtlobTypographySystem.bodyLg.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Current location display
                      if (_currentLocation != null)
                        Container(
                          padding: OtlobSpacingSystem.allMd,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: OtlobComponentSystem.radiusMd,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: OtlobComponentSystem.iconSizeMd,
                              ),
                              SizedBox(width: OtlobSpacingSystem.sm),
                              Text(
                                _currentLocation!,
                                style: OtlobTypographySystem.bodyLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Error message
                      if (_errorMessage != null)
                        Container(
                          margin: OtlobSpacingSystem.verticalMd,
                          padding: OtlobSpacingSystem.allMd,
                          decoration: BoxDecoration(
                            color: OtlobColorSystem.error.withOpacity(0.2),
                            borderRadius: OtlobComponentSystem.radiusMd,
                          ),
                          child: Text(
                            _errorMessage!,
                            style: OtlobTypographySystem.bodyMd.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: OtlobSpacingSystem.xxl),
                    ],
                  ),

                  // Action buttons
                  Column(
                    children: [
                      if (!_hasPermission)
                        PrimaryButton(
                          text: 'السماح بالوصول للموقع',
                          onPressed: _isLoading ? null : _checkLocationPermission,
                          isLoading: _isLoading,
                        ),

                      if (_hasPermission) ...[
                        SizedBox(height: OtlobSpacingSystem.md),
                        PrimaryButton(
                          text: 'متابعة',
                          onPressed: widget.onNext,
                        ),
                        SizedBox(height: OtlobSpacingSystem.sm),
                        SecondaryButton(
                          text: 'تغيير الموقع يدوياً',
                          onPressed: () {
                            // TODO: Show location picker
                          },
                        ),
                      ],
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
}