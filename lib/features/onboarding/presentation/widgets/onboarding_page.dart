import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget imageWidget;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B3A67), Color(0xFF1E2A4A)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image/Placeholder
              SizedBox(height: 250.h, child: imageWidget),
              SizedBox(height: 40.h),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'TutanoCCV2',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              // Subtitle
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  color: Colors.white,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 40.h),
              // Subtle animation placeholder (e.g., fade-in icon)
              AnimatedOpacity(
                opacity: 0.7,
                duration: const Duration(milliseconds: 1500),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
