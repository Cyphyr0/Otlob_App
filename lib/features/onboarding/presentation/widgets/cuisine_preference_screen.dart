import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/otlob_comprehensive_design_system.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';

class CuisinePreferenceScreen extends StatefulWidget {

  const CuisinePreferenceScreen({
    required this.onNext, required this.onCuisinesSelected, super.key,
  });
  final VoidCallback onNext;
  final Function(List<String>) onCuisinesSelected;

  @override
  State<CuisinePreferenceScreen> createState() => _CuisinePreferenceScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<Function(List<String> p1)>.has('onCuisinesSelected', onCuisinesSelected));
  }
}

class _CuisinePreferenceScreenState extends State<CuisinePreferenceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<CuisineItem> _availableCuisines = [
    const CuisineItem(
      id: 'egyptian',
      name: 'مصري',
      nameEnglish: 'Egyptian',
      icon: Icons.local_dining,
      color: OtlobColorSystem.egyptianCuisine,
      description: 'أكلات شعبية مصرية تقليدية',
    ),
    const CuisineItem(
      id: 'shawarma',
      name: 'شاورما',
      nameEnglish: 'Shawarma',
      icon: Icons.wrap_text,
      color: OtlobColorSystem.streetFood,
      description: 'شاورما ولحوم مشوية',
    ),
    const CuisineItem(
      id: 'grill',
      name: 'مشويات',
      nameEnglish: 'Grill',
      icon: Icons.outdoor_grill,
      color: OtlobColorSystem.grill,
      description: 'لحوم ودجاج مشوي',
    ),
    const CuisineItem(
      id: 'seafood',
      name: 'مأكولات بحرية',
      nameEnglish: 'Seafood',
      icon: Icons.set_meal,
      color: OtlobColorSystem.seafood,
      description: 'أسماك ومأكولات بحرية طازجة',
    ),
    const CuisineItem(
      id: 'pizza',
      name: 'بيتزا',
      nameEnglish: 'Pizza',
      icon: Icons.local_pizza,
      color: OtlobColorSystem.streetFood,
      description: 'بيتزا إيطالية متنوعة',
    ),
    const CuisineItem(
      id: 'burgers',
      name: 'برجر',
      nameEnglish: 'Burgers',
      icon: Icons.lunch_dining,
      color: OtlobColorSystem.streetFood,
      description: 'برجر ولحم بقري طازج',
    ),
    const CuisineItem(
      id: 'asian',
      name: 'آسيوي',
      nameEnglish: 'Asian',
      icon: Icons.ramen_dining,
      color: OtlobColorSystem.egyptianSunset,
      description: 'أكلات آسيوية متنوعة',
    ),
    const CuisineItem(
      id: 'desserts',
      name: 'حلويات',
      nameEnglish: 'Desserts',
      icon: Icons.cake,
      color: OtlobColorSystem.desserts,
      description: 'حلويات وحلويات مصرية',
    ),
    const CuisineItem(
      id: 'healthy',
      name: 'صحي',
      nameEnglish: 'Healthy',
      icon: Icons.eco,
      color: OtlobColorSystem.vegetarian,
      description: 'أكلات صحية وخضروات',
    ),
  ];

  final Set<String> _selectedCuisines = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: OtlobAnimationSystem.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: OtlobAnimationSystem.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: OtlobAnimationSystem.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCuisine(String cuisineId) {
    setState(() {
      if (_selectedCuisines.contains(cuisineId)) {
        _selectedCuisines.remove(cuisineId);
      } else {
        _selectedCuisines.add(cuisineId);
      }
    });
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OtlobColorSystem.egyptianSunset,
            OtlobColorSystem.saharaGold,
            OtlobColorSystem.desertSand,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: OtlobSpacingSystem.allLg,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: SecondaryButton(
                      text: 'تخطي',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  const Spacer(),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        padding: OtlobSpacingSystem.allXl,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: OtlobComponentSystem.shadowLg,
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 48.sp,
                          color: OtlobColorSystem.egyptianSunset,
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Title
                      Text(
                        'ما هي أنواع الطعام المفضلة لديك؟',
                        style: OtlobTypographySystem.displayMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.md),

                      Text(
                        'What types of food do you prefer?',
                        style: OtlobTypographySystem.h3.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.lg),

                      // Description
                      Text(
                        'اختر المطابخ التي تفضلها للحصول على توصيات مخصصة',
                        style: OtlobTypographySystem.bodyLgArabic.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.sm),

                      Text(
                        'Choose your preferred cuisines to get personalized recommendations',
                        style: OtlobTypographySystem.bodyLg.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Cuisine selection grid
                      Container(
                        constraints: BoxConstraints(maxHeight: 400.h),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: OtlobSpacingSystem.md,
                            mainAxisSpacing: OtlobSpacingSystem.md,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _availableCuisines.length,
                          itemBuilder: (context, index) {
                            final cuisine = _availableCuisines[index];
                            final isSelected = _selectedCuisines.contains(cuisine.id);

                            return _buildCuisineCard(cuisine, isSelected);
                          },
                        ),
                      ),

                      SizedBox(height: OtlobSpacingSystem.xl),

                      // Selection summary
                      if (_selectedCuisines.isNotEmpty)
                        Container(
                          padding: OtlobSpacingSystem.allMd,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: OtlobComponentSystem.radiusMd,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'تم اختيار ${_selectedCuisines.length} أنواع من المطابخ',
                            style: OtlobTypographySystem.bodyLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: OtlobSpacingSystem.xxl),
                    ],
                  ),

                  // Action buttons
                  Column(
                    children: [
                      PrimaryButton(
                        text: _selectedCuisines.isEmpty ? 'تخطي هذه الخطوة' : 'متابعة',
                        onPressed: () {
                          widget.onCuisinesSelected(_selectedCuisines.toList());
                          widget.onNext();
                        },
                      ),

                      if (_selectedCuisines.isNotEmpty)
                        SizedBox(height: OtlobSpacingSystem.sm),

                      if (_selectedCuisines.isNotEmpty)
                        SecondaryButton(
                          text: 'مسح الكل',
                          onPressed: () {
                            setState(_selectedCuisines.clear);
                          },
                        ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildCuisineCard(CuisineItem cuisine, bool isSelected) => GestureDetector(
      onTap: () => _toggleCuisine(cuisine.id),
      child: AnimatedContainer(
        duration: OtlobAnimationSystem.durationFast,
        padding: OtlobSpacingSystem.allMd,
        decoration: BoxDecoration(
          color: isSelected
              ? cuisine.color.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: OtlobComponentSystem.radiusLg,
          border: Border.all(
            color: isSelected
                ? cuisine.color
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cuisine.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: OtlobSpacingSystem.allMd,
              decoration: BoxDecoration(
                color: isSelected
                    ? cuisine.color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                cuisine.icon,
                size: 32.sp,
                color: isSelected ? cuisine.color : Colors.white,
              ),
            ),

            SizedBox(height: OtlobSpacingSystem.md),

            // Name
            Text(
              cuisine.name,
              style: OtlobTypographySystem.bodyLg.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: OtlobSpacingSystem.xs),

            Text(
              cuisine.nameEnglish,
              style: OtlobTypographySystem.bodySm.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: OtlobSpacingSystem.sm),

            // Description
            Text(
              cuisine.description,
              style: OtlobTypographySystem.bodySm.copyWith(
                color: Colors.white.withOpacity(0.6),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: OtlobSpacingSystem.sm),

            // Selection indicator
            if (isSelected)
              Container(
                padding: OtlobSpacingSystem.horizontalSm,
                decoration: BoxDecoration(
                  color: cuisine.color,
                  borderRadius: OtlobComponentSystem.radiusFull,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: OtlobComponentSystem.iconSizeSm,
                ),
              ),
          ],
        ),
      ),
    );
}

class CuisineItem {

  const CuisineItem({
    required this.id,
    required this.name,
    required this.nameEnglish,
    required this.icon,
    required this.color,
    required this.description,
  });
  final String id;
  final String name;
  final String nameEnglish;
  final IconData icon;
  final Color color;
  final String description;
}