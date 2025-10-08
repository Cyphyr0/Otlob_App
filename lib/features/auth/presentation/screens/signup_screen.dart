import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/branding/otlob_logo.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../../../../core/widgets/inputs/custom_text_field.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Basic validation
    var name = _nameController.text.trim();
    var email = _emailController.text.trim();
    var password = _passwordController.text;
    var confirmPassword = _confirmPasswordController.text;
    var hasError = false;
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter your name');
      hasError = true;
    } else if (name.length < 2) {
      setState(() => _nameError = 'Name must be at least 2 characters');
      hasError = true;
    }
    if (email.isEmpty) {
      setState(() => _emailError = 'Please enter your email');
      hasError = true;
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email');
      hasError = true;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Please enter a password');
      hasError = true;
    } else if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      hasError = true;
    }
    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = 'Please confirm your password');
      hasError = true;
    } else if (password != confirmPassword) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      hasError = true;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      hasError = true;
    }
    if (hasError) return;

    setState(() => _isLoading = true);
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signUpWithEmail(name, email, password);
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go('/home');
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      var msg = e.message.isNotEmpty
          ? e.message
          : 'Sign up failed. Please try again.';
      if (msg.toLowerCase().contains('email')) {
        setState(() => _emailError = msg);
      } else if (msg.toLowerCase().contains('password')) {
        setState(() => _passwordError = msg);
      } else if (msg.toLowerCase().contains('name')) {
        setState(() => _nameError = msg);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign Up Error'),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign Up Error'),
          content: Text('An unexpected error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithGoogle();
      if (mounted) {
        context.go('/home');
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
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithFacebook();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Facebook sign-in failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.allMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.lg),

                // Otlob Logo
                const Center(child: OtlobLogo(size: LogoSize.large)),

                SizedBox(height: AppSpacing.lg),

                // Join Otlob Title
                Text(
                  'Join Otlob',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.xs),

                Text(
                  'Create your account to start ordering',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.sectionSpacing),

                // Name Field
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  errorText: _nameError,
                  onChanged: (_) => setState(() => _nameError = null),
                ),

                SizedBox(height: AppSpacing.md),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorText: _emailError,
                  onChanged: (_) => setState(() => _emailError = null),
                ),

                SizedBox(height: AppSpacing.md),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  errorText: _passwordError,
                  onChanged: (_) => setState(() => _passwordError = null),
                ),

                SizedBox(height: AppSpacing.md),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  errorText: _confirmPasswordError,
                  onChanged: (_) =>
                      setState(() => _confirmPasswordError = null),
                  onSubmitted: (_) => _handleSignup(),
                ),

                SizedBox(height: AppSpacing.md),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() => _acceptedTerms = value ?? false);
                      },
                      activeColor: AppColors.accentOrange,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _acceptedTerms = !_acceptedTerms);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.darkGray,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Sign Up Button
                PrimaryButton(
                  text: 'Sign Up',
                  onPressed: _isLoading ? null : _handleSignup,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                SizedBox(height: AppSpacing.lg),

                // Divider with OR
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.lightGray)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.lightGray)),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                // Google Sign Up Button
                _SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Sign up with Google',
                  backgroundColor: AppColors.white,
                  textColor: AppColors.darkGray,
                  onPressed: _signInWithGoogle,
                ),

                SizedBox(height: AppSpacing.md),

                // Facebook Sign Up Button
                _SocialLoginButton(
                  icon: Icons.facebook,
                  label: 'Sign up with Facebook',
                  backgroundColor: const Color(0xFF4267B2),
                  textColor: AppColors.white,
                  onPressed: _signInWithFacebook,
                ),

                SizedBox(height: AppSpacing.lg),

                // Already have account? Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Log In',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.accentOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Skip for now button
                SecondaryButton(
                  text: 'Skip for now',
                  onPressed: () => context.go('/home'),
                  fullWidth: true,
                ),

                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
}

class _SocialLoginButton extends StatelessWidget {

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(
            color: backgroundColor == AppColors.white
                ? AppColors.lightGray
                : backgroundColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('label', label));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
