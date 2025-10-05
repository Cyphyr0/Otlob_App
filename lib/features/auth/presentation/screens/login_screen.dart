import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/theme/app_colors.dart';
import 'package:otlob_app/core/theme/app_typography.dart';
import 'package:otlob_app/core/theme/app_spacing.dart';
import 'package:otlob_app/core/widgets/branding/otlob_logo.dart';
import 'package:otlob_app/core/widgets/buttons/primary_button.dart';
import 'package:otlob_app/core/widgets/buttons/secondary_button.dart';
import 'package:otlob_app/core/widgets/inputs/custom_text_field.dart';
import 'package:otlob_app/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Basic validation
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Please enter your password');
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement actual email/password login
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  Future<void> _signInWithGoogle() async {
    final authNotifier = ref.read(authProvider.notifier);
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
    final authNotifier = ref.read(authProvider.notifier);
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

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Forgot Password', style: AppTypography.titleMedium),
        content: Text(
          'Password reset feature will be implemented soon. For now, please use social login.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          PrimaryButton(text: 'OK', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.allMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xl),

                // Otlob Logo
                Center(child: OtlobLogo(size: LogoSize.large)),

                SizedBox(height: AppSpacing.lg),

                // Welcome Back Title
                Text(
                  'Welcome Back',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.xs),

                Text(
                  'Login to continue ordering delicious food',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.sectionSpacing),

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
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  errorText: _passwordError,
                  onChanged: (_) => setState(() => _passwordError = null),
                  onSubmitted: (_) => _handleLogin(),
                ),

                SizedBox(height: AppSpacing.sm),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Login Button
                PrimaryButton(
                  text: 'Login',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),

                SizedBox(height: AppSpacing.lg),

                // Divider with OR
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.lightGray)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.lightGray)),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                // Google Login Button
                _SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Continue with Google',
                  backgroundColor: AppColors.white,
                  textColor: AppColors.darkGray,
                  onPressed: _signInWithGoogle,
                ),

                SizedBox(height: AppSpacing.md),

                // Facebook Login Button
                _SocialLoginButton(
                  icon: Icons.facebook,
                  label: 'Continue with Facebook',
                  backgroundColor: const Color(0xFF4267B2),
                  textColor: AppColors.white,
                  onPressed: _signInWithFacebook,
                ),

                SizedBox(height: AppSpacing.lg),

                // Don't have account? Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
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
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
  }
}
