import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/errors/failures.dart';
import 'package:otlob_app/core/theme/app_theme.dart';
import 'package:otlob_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:otlob_app/features/auth/presentation/widgets/why_otlob_section.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = '+20${_phoneController.text.trim()}';
    if (_phoneController.text.length != 10) {
      setState(() {
        _errorText = 'Please enter a valid Egyptian phone number (10 digits)';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.sendOTP(phone);
      if (mounted) {
        context.push('/phone-verification', extra: phone);
      }
    } on AuthFailure catch (e) {
      if (mounted) {
        setState(() {
          _errorText = e.message;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithGoogle();
      if (mounted) {
        context.go('/address');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
      }
    }
  }

  Future<void> _signInWithFacebook() async {
    final authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithFacebook();
      if (mounted) {
        context.go('/address');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Facebook sign-in failed: $e')));
      }
    }
  }

  // DISABLED: Apple Sign-in - Not implemented for now
  // Future<void> _signInWithApple() async {
  //   final authNotifier = ref.read(authProvider.notifier);
  //   try {
  //     await authNotifier.signInWithApple();
  //     if (mounted) {
  //       context.go('/address');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Apple sign-in failed: $e')));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Text(
                    'Join Otlob!',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'TutanoCCV2',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your details to get started',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: 'Enter your full name',
                      hintStyle: TextStyle(color: Colors.white54),
                      errorText: _errorText,
                      errorStyle: const TextStyle(color: Colors.red),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppTheme.secondaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixText: '+20 ',
                      prefixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintText: 'Enter 10 digit phone number',
                      hintStyle: TextStyle(color: Colors.white54),
                      errorText: _errorText,
                      errorStyle: const TextStyle(color: Colors.red),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppTheme.secondaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithGoogle,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.white,
                          ),
                          label: const Text('Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithFacebook,
                          icon: const Icon(Icons.facebook, color: Colors.white),
                          label: const Text('Facebook'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4267B2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // DISABLED: Apple Sign-in button - Not implemented for now
                  // if (Theme.of(context).platform == TargetPlatform.iOS)
                  //   SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton.icon(
                  //       onPressed: _signInWithApple,
                  //       icon: const Icon(Icons.apple, color: Colors.black),
                  //       label: const Text('Apple'),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.black,
                  //         foregroundColor: Colors.white,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.r),
                  //         ),
                  //         padding: EdgeInsets.symmetric(vertical: 12.h),
                  //       ),
                  //     ),
                  //   ),
                  SizedBox(height: 40.h),

                  // Guest Mode - Skip Sign Up
                  TextButton(
                    onPressed: () {
                      // Navigate to home without authentication
                      context.go('/home');
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  const WhyOtlobSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
