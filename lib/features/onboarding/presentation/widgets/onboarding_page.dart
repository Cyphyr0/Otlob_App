import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/shadcn_theme.dart';

class OnboardingPage extends StatelessWidget {

  const OnboardingPage({
    required this.title, required this.subtitle, required this.imageWidget, super.key,
  });
  final String title;
  final String subtitle;
  final Widget imageWidget;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.primary,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image/Placeholder
                  ShadcnTheme.shadcnCard(
                    padding: EdgeInsets.all(24.w),
                    child: SizedBox(height: 200.h, child: imageWidget),
                  ),
                  SizedBox(height: 40.h),
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
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
                      color: theme.colorScheme.onPrimary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('subtitle', subtitle));
  }
}
