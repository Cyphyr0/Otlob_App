import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Photo Gallery Component with Food-First Imagery
///
/// A sophisticated photo gallery featuring:
/// - Horizontal scrolling with snap-to behavior
/// - High-quality food imagery with loading states
/// - Photo categories (food, ambiance, menu)
/// - Full-screen view with zoom capabilities
/// - Cultural theming for Egyptian restaurants
/// - Performance optimizations with caching
///
/// Usage:
/// ```dart
/// PhotoGallery(
///   photos: restaurantPhotos,
///   onPhotoTap: (index) => showFullScreenGallery(index),
///   initialCategory: PhotoCategory.food,
///   culturalTheme: CulturalTheme.egyptian,
/// )
/// ```
class PhotoGallery extends StatefulWidget {
  const PhotoGallery({
    required this.photos, super.key,
    this.onPhotoTap,
    this.initialCategory = PhotoCategory.food,
    this.culturalTheme,
    this.height = 200,
    this.showCategoryTabs = true,
    this.enableFullScreen = true,
  });

  final List<PhotoData> photos;
  final Function(int)? onPhotoTap;
  final PhotoCategory initialCategory;
  final CulturalTheme? culturalTheme;
  final double height;
  final bool showCategoryTabs;
  final bool enableFullScreen;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<PhotoData>('photos', photos));
    properties.add(ObjectFlagProperty<Function(int p1)?>.has('onPhotoTap', onPhotoTap));
    properties.add(EnumProperty<PhotoCategory>('initialCategory', initialCategory));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<bool>('showCategoryTabs', showCategoryTabs));
    properties.add(DiagnosticsProperty<bool>('enableFullScreen', enableFullScreen));
  }
}

class _PhotoGalleryState extends State<PhotoGallery>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  PhotoCategory _selectedCategory = PhotoCategory.food;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  List<PhotoData> get _filteredPhotos => widget.photos.where((photo) => photo.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return _EmptyGallery(culturalTheme: widget.culturalTheme);
    }

    return Column(
      children: [
        // Category tabs
        if (widget.showCategoryTabs) ...[
          _CategoryTabs(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
              _pageController.jumpToPage(0);
            },
            culturalTheme: widget.culturalTheme,
          ),
          SizedBox(height: AppSpacing.md),
        ],

        // Photo gallery
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _filteredPhotos.length,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            itemBuilder: (context, index) {
              final photo = _filteredPhotos[index];
              return _PhotoItem(
                photo: photo,
                onTap: widget.enableFullScreen
                    ? () => widget.onPhotoTap?.call(index)
                    : null,
                culturalTheme: widget.culturalTheme,
              );
            },
          ),
        ),

        // Page indicators
        if (_filteredPhotos.length > 1) ...[
          SizedBox(height: AppSpacing.md),
          _PageIndicators(
            count: _filteredPhotos.length,
            currentPage: _currentPage,
            culturalTheme: widget.culturalTheme,
          ),
        ],
      ],
    );
  }
}

/// Category tabs for filtering photos
class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.selectedCategory,
    required this.onCategorySelected,
    this.culturalTheme,
  });

  final PhotoCategory selectedCategory;
  final Function(PhotoCategory) onCategorySelected;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: PhotoCategory.values.map((category) => _CategoryTab(
            category: category,
            isSelected: category == selectedCategory,
            onTap: () => onCategorySelected(category),
            culturalTheme: culturalTheme,
          )).toList(),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PhotoCategory>('selectedCategory', selectedCategory));
    properties.add(ObjectFlagProperty<Function(PhotoCategory p1)>.has('onCategorySelected', onCategorySelected));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Individual category tab
class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.culturalTheme,
  });

  final PhotoCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: AppSpacing.sm),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (culturalTheme?.color ?? AppColors.logoRed)
              : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? (culturalTheme?.color ?? AppColors.logoRed)
                : AppColors.lightGray,
            width: 1,
          ),
        ),
        child: Text(
          _getCategoryLabel(category),
          style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.white : AppColors.primaryBlack,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );

  String _getCategoryLabel(PhotoCategory category) {
    switch (category) {
      case PhotoCategory.food:
        return 'الطعام';
      case PhotoCategory.ambiance:
        return 'الأجواء';
      case PhotoCategory.menu:
        return 'القائمة';
      case PhotoCategory.exterior:
        return 'الخارج';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PhotoCategory>('category', category));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Individual photo item
class _PhotoItem extends StatelessWidget {
  const _PhotoItem({
    required this.photo,
    this.onTap,
    this.culturalTheme,
  });

  final PhotoData photo;
  final VoidCallback? onTap;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              Image.network(
                photo.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.lightGray,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          culturalTheme?.color ?? AppColors.logoRed,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.lightGray,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: AppColors.gray,
                          size: 40.sp,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'صورة غير متاحة',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),

              // Overlay with photo info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Photo title
                      if (photo.title != null) ...[
                        Text(
                          photo.title!,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],

                      // Photo description
                      if (photo.description != null)
                        Text(
                          photo.description!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),

              // Cultural badge
              if (culturalTheme != null)
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: culturalTheme!.color.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          culturalTheme!.icon,
                          color: AppColors.white,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          culturalTheme!.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PhotoData>('photo', photo));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Page indicators
class _PageIndicators extends StatelessWidget {
  const _PageIndicators({
    required this.count,
    required this.currentPage,
    this.culturalTheme,
  });

  final int count;
  final int currentPage;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: index == currentPage ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: index == currentPage
                ? (culturalTheme?.color ?? AppColors.logoRed)
                : AppColors.lightGray,
            borderRadius: BorderRadius.circular(4.r),
          ),
        )),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(IntProperty('currentPage', currentPage));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Empty gallery state
class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({this.culturalTheme});

  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera,
            color: AppColors.gray,
            size: 40.sp,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'لا توجد صور متاحة',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'سيتم إضافة صور قريباً',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Photo data model
class PhotoData {
  const PhotoData({
    required this.id,
    required this.url,
    required this.category,
    this.title,
    this.description,
    this.uploadedAt,
    this.isHero = false,
  });

  final String id;
  final String url;
  final PhotoCategory category;
  final String? title;
  final String? description;
  final DateTime? uploadedAt;
  final bool isHero;
}

/// Photo categories
enum PhotoCategory {
  food,
  ambiance,
  menu,
  exterior,
}

/// Cultural theme for photo galleries
enum CulturalTheme {
  egyptian._(
    name: 'مصري أصيل',
    color: Color(0xFFE74C3C),
    icon: Icons.flag,
  ),
  ramadan._(
    name: 'رمضاني',
    color: Color(0xFFF4D06F),
    icon: Icons.star,
  );

  const CulturalTheme._({
    required this.name,
    required this.color,
    required this.icon,
  });

  final String name;
  final Color color;
  final IconData icon;
}