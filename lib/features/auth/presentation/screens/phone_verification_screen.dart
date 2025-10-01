import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/errors/failures.dart';
import 'package:otlob_app/core/theme/app_theme.dart';
import 'package:otlob_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:otlob_app/features/auth/presentation/widgets/why_otlob_section.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _otpController;
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();
  String otp = '';
  int resendTime = 60;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    _otpController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _timerController.forward();
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          canResend = true;
        });
      }
    });
    _setupOtpListeners();
  }

  void _setupOtpListeners() {
    _otpController1.addListener(() {
      if (_otpController1.text.length == 1) {
        FocusScope.of(context).nextFocus();
      }
      _updateOtp();
    });
    _otpController2.addListener(() {
      if (_otpController2.text.length == 1) {
        FocusScope.of(context).nextFocus();
      }
      _updateOtp();
    });
    _otpController3.addListener(() {
      if (_otpController3.text.length == 1) {
        FocusScope.of(context).nextFocus();
      }
      _updateOtp();
    });
    _otpController4.addListener(() {
      if (_otpController4.text.length == 1) {
        FocusScope.of(context).nextFocus();
      }
      _updateOtp();
    });
    _otpController5.addListener(() {
      if (_otpController5.text.length == 1) {
        FocusScope.of(context).nextFocus();
      }
      _updateOtp();
    });
    _otpController6.addListener(() {
      _updateOtp();
    });
  }

  void _updateOtp() {
    otp = [
      _otpController1.text,
      _otpController2.text,
      _otpController3.text,
      _otpController4.text,
      _otpController5.text,
      _otpController6.text,
    ].join();
    if (otp.length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.verifyOTP(otp, widget.phoneNumber);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification successful!')),
        );
        context.go('/address');
      }
    } on AuthFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      // Clear OTP
      _clearOtp();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    }
  }

  void _clearOtp() {
    _otpController1.clear();
    _otpController2.clear();
    _otpController3.clear();
    _otpController4.clear();
    _otpController5.clear();
    _otpController6.clear();
    otp = '';
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _resendOtp() async {
    setState(() {
      canResend = false;
      resendTime = 60;
    });
    _timerController.reset();
    _timerController.forward();
    _clearOtp();
    // Mock resend
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP resent!')));
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    _otpController.dispose();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _otpController5.dispose();
    _otpController6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsyncValue = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B3A67), Color(0xFF1E2A44)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Text(
                  'Verify your phone',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'TutanoCCV2',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter the 6-digit code sent to +20 ${widget.phoneNumber}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpField(_otpController1),
                    _buildOtpField(_otpController2),
                    _buildOtpField(_otpController3),
                    _buildOtpField(_otpController4),
                    _buildOtpField(_otpController5),
                    _buildOtpField(_otpController6),
                  ],
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: otp.length == 6 ? null : () => _verifyOtp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: authAsyncValue.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _timerController,
                      builder: (context, child) {
                        return Text(
                          canResend
                              ? 'Resend OTP'
                              : 'Resend in ${resendTime - _timerController.value.toInt()}s',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: canResend ? _resendOtp : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: canResend
                              ? AppTheme.secondaryColor
                              : Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                const WhyOtlobSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(TextEditingController controller) {
    return SizedBox(
      width: 50.w,
      height: 60.h,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(
              color: AppTheme.secondaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
