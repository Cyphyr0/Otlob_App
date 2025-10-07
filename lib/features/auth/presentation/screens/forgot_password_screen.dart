import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_typography.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/widgets/buttons/primary_button.dart";
import "../../../../core/widgets/inputs/custom_text_field.dart";
import "../providers/auth_provider.dart";

// Note: This widget uses Riverpod to call the password reset provider method.

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    setState(() {
      _emailError = null;
    });

    var email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = "Please enter your email");
      return;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      setState(() => _emailError = "Please enter a valid email");
      return;
    }

    setState(() => _isLoading = true);
    try {
      var notifier = ref.read(authProvider.notifier);
      await notifier.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password reset", style: AppTypography.titleMedium),
          content: const Text("If that email exists we sent a reset link."),
          actions: [
            PrimaryButton(text: "OK", onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send reset link: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        backgroundColor: AppColors.offWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.allMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.lg),
              Text(
                'Reset your password',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Enter your account email and we will send a password reset link.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
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
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleReset(),
              ),

              SizedBox(height: AppSpacing.md),

              PrimaryButton(
                text: 'Send Reset Link',
                onPressed: _isLoading ? null : _handleReset,
                isLoading: _isLoading,
              ),

              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
}
