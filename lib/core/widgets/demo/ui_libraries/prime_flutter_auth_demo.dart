import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class PrimeFlutterAuthDemo extends StatefulWidget {
  const PrimeFlutterAuthDemo({super.key});

  @override
  State<PrimeFlutterAuthDemo> createState() => _PrimeFlutterAuthDemoState();
}

class _PrimeFlutterAuthDemoState extends State<PrimeFlutterAuthDemo> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _handleSubmit() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isLogin
                  ? 'Prime Flutter Login Successful'
                  : 'Prime Flutter Account Created',
            ),
            backgroundColor: AppColors.logoRed,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Login with Prime Flutter' : 'Sign Up with Prime Flutter',
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.logoRed, AppColors.primaryGold],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    _isLogin ? Icons.login : Icons.person_add,
                    size: 48.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Prime Flutter UI Library',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  _isLogin
                      ? 'Sign in to your account to continue'
                      : 'Join Otlob and discover great food',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),

            // Form
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.lightGray.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isLogin) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],

                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.logoRed, AppColors.primaryGold],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.logoRed.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _isLogin ? 'Sign In' : 'Create Account',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Sign In',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.logoRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Social Login
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'Or continue with',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata, size: 20),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGray,
                      padding: AppSpacing.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.facebook, size: 20),
                    label: const Text('Continue with Facebook'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGray,
                      padding: AppSpacing.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),

            // Prime Flutter Features Note
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGold.withOpacity(0.1),
                    AppColors.logoRed.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Prime Flutter Features',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primaryBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '• Premium component library\n• Advanced theming\n• Rich animations\n• Form validation\n• Data tables\n• Charts & graphs\n• Calendar components\n• Advanced dialogs',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryBlack,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
