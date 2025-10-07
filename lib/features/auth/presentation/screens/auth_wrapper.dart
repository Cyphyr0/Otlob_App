import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../../core/widgets/branding/otlob_logo.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../../../../core/widgets/inputs/custom_text_field.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper>
    with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = math.min(constraints.maxWidth * 0.95, 520);
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    // Header with logo
                    Padding(
                      padding: AppSpacing.allLg,
                      child: Column(
                        children: [
                          SizedBox(height: AppSpacing.md),
                          const Center(child: OtlobLogo(size: LogoSize.large)),
                          SizedBox(height: AppSpacing.lg),

                          // Tab bar
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.lightGray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: AppColors.white,
                              unselectedLabelColor: AppColors.darkGray,
                              indicator: BoxDecoration(
                                color: AppColors.logoRed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelStyle: AppTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: const [
                                Tab(text: 'Login'),
                                Tab(text: 'Sign Up'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [_LoginTab(), _SignupTab()],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
}

// Login Tab Content
class _LoginTab extends ConsumerStatefulWidget {
  const _LoginTab();

  @override
  ConsumerState<_LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends ConsumerState<_LoginTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Please enter your password');
      return;
    }

    setState(() => _isLoading = true);
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithGoogle();
      if (mounted) context.go('/home');
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
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Facebook sign-in failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Login to continue ordering',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sectionSpacing),

          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            onChanged: (_) => setState(() => _emailError = null),
          ),
          SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            errorText: _passwordError,
            onChanged: (_) => setState(() => _passwordError = null),
            onSubmitted: (_) => _handleLogin(),
          ),
          SizedBox(height: AppSpacing.md),

          PrimaryButton(
            text: 'Login',
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
            fullWidth: true,
          ),
          SizedBox(height: AppSpacing.lg),

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

          _SocialButton(
            icon: Icons.g_mobiledata,
            label: 'Continue with Google',
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: AppSpacing.md),

          _SocialButton(
            icon: Icons.facebook,
            label: 'Continue with Facebook',
            onPressed: _signInWithFacebook,
          ),
          SizedBox(height: AppSpacing.lg),

          SecondaryButton(
            text: 'Skip for now',
            onPressed: () async {
              // Set as authenticated for demo purposes
              final authNotifier = ref.read(authProvider.notifier);
              await authNotifier.logout(); // This sets authenticated to false
              // Actually, let's just navigate and let the redirect handle it
              // For now, we'll modify to set authenticated
              await SharedPrefsHelper.setAuthenticated(true);
              if (mounted) context.go('/home');
            },
            fullWidth: true,
          ),
        ],
      ),
    );
}

// Signup Tab Content
class _SignupTab extends ConsumerStatefulWidget {
  const _SignupTab();

  @override
  ConsumerState<_SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends ConsumerState<_SignupTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

    var hasError = false;

    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Please enter your name');
      hasError = true;
    }
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Please enter your email');
      hasError = true;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Please enter a password');
      hasError = true;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      hasError = true;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and conditions')),
      );
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);
    var authNotifier = ref.read(authProvider.notifier);
    try {
       await authNotifier.signUpWithEmail(
         _nameController.text.trim(),
         _emailController.text.trim(),
         _passwordController.text,
       );

       // Send email verification after successful signup
       try {
         await authNotifier.sendEmailVerification();
         if (mounted) {
           _showEmailVerificationDialog();
         }
       } catch (verificationError) {
         // Email verification failed but signup succeeded
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Account created! Please check your email to verify your account.'),
               backgroundColor: Colors.orange,
             ),
           );
           context.go('/home');
         }
       }
     } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(
           context,
         ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
       }
     } finally {
       if (mounted) setState(() => _isLoading = false);
     }
  }

  Future<void> _signInWithGoogle() async {
    var authNotifier = ref.read(authProvider.notifier);
    try {
      await authNotifier.signInWithGoogle();
      if (mounted) context.go('/home');
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
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Facebook sign-in failed: $e')));
      }
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Verify your email',
          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark),
        ),
        content: Text(
          "We've sent a verification link to your email address. Please check your email and click the link to verify your account before continuing.",
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
        ),
        actions: [
          PrimaryButton(
            text: 'Continue to Home',
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
          ),
          SecondaryButton(
            text: 'Resend verification',
            onPressed: () async {
              try {
                var authNotifier = ref.read(authProvider.notifier);
                await authNotifier.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification email sent!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to resend: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Join Otlob',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Create your account to start',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sectionSpacing),

          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your name',
            prefixIcon: Icons.person_outline,
            errorText: _nameError,
            onChanged: (_) => setState(() => _nameError = null),
          ),
          SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            onChanged: (_) => setState(() => _emailError = null),
          ),
          SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            errorText: _passwordError,
            onChanged: (_) => setState(() => _passwordError = null),
          ),
          SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            errorText: _confirmPasswordError,
            onChanged: (_) => setState(() => _confirmPasswordError = null),
            onSubmitted: (_) => _handleSignup(),
          ),
          SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (value) =>
                    setState(() => _acceptedTerms = value ?? false),
                activeColor: AppColors.logoRed,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: AppTypography.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.logoRed,
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

          PrimaryButton(
            text: 'Sign Up',
            onPressed: _isLoading ? null : _handleSignup,
            isLoading: _isLoading,
            fullWidth: true,
          ),
          SizedBox(height: AppSpacing.lg),

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

          _SocialButton(
            icon: Icons.g_mobiledata,
            label: 'Sign up with Google',
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: AppSpacing.md),

          _SocialButton(
            icon: Icons.facebook,
            label: 'Sign up with Facebook',
            onPressed: _signInWithFacebook,
          ),
          SizedBox(height: AppSpacing.lg),

          SecondaryButton(
            text: 'Skip for now',
            onPressed: () async {
              // Set as authenticated for demo purposes
              await SharedPrefsHelper.setAuthenticated(true);
              if (mounted) context.go('/home');
            },
            fullWidth: true,
          ),
        ],
      ),
    );
}

// Social Button Widget
class _SocialButton extends StatelessWidget {

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.darkGray),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkGray,
          side: const BorderSide(color: AppColors.lightGray),
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
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
