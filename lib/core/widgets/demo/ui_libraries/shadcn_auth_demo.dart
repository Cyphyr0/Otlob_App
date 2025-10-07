import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "../../../theme/app_colors.dart";
import "../../../theme/app_spacing.dart";
import "../../../theme/app_typography.dart";

class ShadcnAuthDemo extends StatefulWidget {
  const ShadcnAuthDemo({super.key});

  @override
  State<ShadcnAuthDemo> createState() => _ShadcnAuthDemoState();
}

class _ShadcnAuthDemoState extends State<ShadcnAuthDemo> {
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
            content: Text(_isLogin ? "Login Successful" : "Account Created"),
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
          _isLogin ? 'Login with Shadcn UI' : 'Sign Up with Shadcn UI',
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
                Icon(
                  _isLogin ? Icons.login : Icons.person_add,
                  size: 64.sp,
                  color: AppColors.logoRed,
                ),
                SizedBox(height: AppSpacing.md),
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
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      obscureText: true,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.logoRed,
                        foregroundColor: Colors.white,
                        padding: AppSpacing.buttonPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
                          : Text(_isLogin ? 'Sign In' : 'Create Account'),
                    ),

                    SizedBox(height: AppSpacing.md),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
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

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 20),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkGray,
                    side: const BorderSide(color: Colors.grey),
                    padding: AppSpacing.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook, size: 20),
                  label: const Text('Continue with Facebook'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkGray,
                    side: const BorderSide(color: Colors.grey),
                    padding: AppSpacing.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
}
