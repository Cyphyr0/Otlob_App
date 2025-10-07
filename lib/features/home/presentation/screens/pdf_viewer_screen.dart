import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({
    required this.pdfUrl, required this.title, super.key,
  });

  final String pdfUrl;
  final String title;

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('pdfUrl', pdfUrl));
    properties.add(StringProperty('title', title));
  }
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: _isReady && _totalPages > 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(40.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 16.sp),
                        onPressed: _currentPage > 1
                            ? () {
                                _pdfViewController?.setPage(_currentPage - 1);
                              }
                            : null,
                      ),
                      Text(
                        '$_currentPage / $_totalPages',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16.sp),
                        onPressed: _currentPage < _totalPages
                            ? () {
                                _pdfViewController?.setPage(_currentPage + 1);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            fitEachPage: true,
            onRender: (pages) {
              setState(() {
                _totalPages = pages!;
                _isReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page!;
                _totalPages = total!;
              });
            },
          ),
          if (!_isReady)
            Container(
              color: AppColors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.logoRed),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Loading PDF...',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
}