import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/modern_button_variants.dart';
import '../cards/enhanced_card.dart';

/// Menu Item Card with Customization Options
///
/// A sophisticated menu item component featuring:
/// - High-quality food imagery
/// - Customization options (size, add-ons, special requests)
/// - Quantity selector
/// - Dietary indicators and allergens
/// - Price display with cultural currency formatting
/// - Add to cart functionality
///
/// Usage:
/// ```dart
/// MenuItemCard(
///   item: menuItem,
///   onAddToCart: (customization) => addToCart(item, customization),
///   showCustomization: true,
///   culturalCurrency: true,
/// )
/// ```
class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    required this.item, super.key,
    this.onAddToCart,
    this.onQuantityChanged,
    this.showCustomization = true,
    this.culturalCurrency = true,
    this.size = MenuCardSize.medium,
  });

  final MenuItemData item;
  final Function(MenuCustomization)? onAddToCart;
  final Function(int)? onQuantityChanged;
  final bool showCustomization;
  final bool culturalCurrency;
  final MenuCardSize size;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuItemData>('item', item));
    properties.add(ObjectFlagProperty<Function(MenuCustomization p1)?>.has('onAddToCart', onAddToCart));
    properties.add(ObjectFlagProperty<Function(int p1)?>.has('onQuantityChanged', onQuantityChanged));
    properties.add(DiagnosticsProperty<bool>('showCustomization', showCustomization));
    properties.add(DiagnosticsProperty<bool>('culturalCurrency', culturalCurrency));
    properties.add(EnumProperty<MenuCardSize>('size', size));
  }
}

class _MenuItemCardState extends State<MenuItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _quantity = 1;
  bool _showCustomization = false;
  MenuCustomization _customization = const MenuCustomization();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onAddToCart?.call(_customization);
    });
  }

  void _toggleCustomization() {
    setState(() {
      _showCustomization = !_showCustomization;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = _getCardConfig();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: EnhancedCard(
          elevation: CardElevation.low,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              // Main content
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item image
                    _ItemImage(
                      imageUrl: widget.item.imageUrl,
                      size: config.imageSize,
                    ),

                    SizedBox(width: AppSpacing.md),

                    // Item details
                    Expanded(
                      child: _ItemDetails(
                        item: widget.item,
                        culturalCurrency: widget.culturalCurrency,
                      ),
                    ),

                    // Quantity and add button
                    _QuantitySelector(
                      quantity: _quantity,
                      onQuantityChanged: (quantity) {
                        setState(() => _quantity = quantity);
                        widget.onQuantityChanged?.call(quantity);
                      },
                      onAdd: _handleAddToCart,
                    ),
                  ],
                ),
              ),

              // Customization section
              if (_showCustomization)
                _CustomizationSection(
                  customization: _customization,
                  onCustomizationChanged: (customization) {
                    setState(() => _customization = customization);
                  },
                  onClose: _toggleCustomization,
                ),
            ],
          ),
        ),
      ),
    );
  }

  CardConfig _getCardConfig() {
    switch (widget.size) {
      case MenuCardSize.small:
        return CardConfig(
          imageSize: 50.w,
          height: 80.h,
        );
      case MenuCardSize.medium:
        return CardConfig(
          imageSize: 70.w,
          height: 120.h,
        );
      case MenuCardSize.large:
        return CardConfig(
          imageSize: 90.w,
          height: 140.h,
        );
    }
  }
}

/// Item image with loading state
class _ItemImage extends StatelessWidget {
  const _ItemImage({
    required this.imageUrl,
    required this.size,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.lightGray,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.logoRed),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.lightGray,
              child: Icon(
                Icons.restaurant,
                color: AppColors.gray,
                size: size * 0.4,
              ),
            ),
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('imageUrl', imageUrl));
    properties.add(DoubleProperty('size', size));
  }
}

/// Item details section
class _ItemDetails extends StatelessWidget {
  const _ItemDetails({
    required this.item,
    required this.culturalCurrency,
  });

  final MenuItemData item;
  final bool culturalCurrency;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item name and dietary indicators
        Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.isVegetarian || item.isVegan || item.isSpicy)
              _DietaryIndicators(item: item),
          ],
        ),

        SizedBox(height: 4.h),

        // Description
        Text(
          item.description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.gray,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: AppSpacing.sm),

        // Price and customization hint
        Row(
          children: [
            // Price
            Text(
              culturalCurrency
                  ? '${item.price} جنيه'
                  : '${item.price} EGP',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.logoRed,
              ),
            ),

            const Spacer(),

            // Customization hint
            if (item.hasCustomizations)
              GestureDetector(
                onTap: () {}, // This would be handled by parent
                child: Text(
                  'تخصيص',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.logoRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),

        // Allergen info
        if (item.allergens.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            'يحتوي على: ${item.allergens.join(", ")}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.warning,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuItemData>('item', item));
    properties.add(DiagnosticsProperty<bool>('culturalCurrency', culturalCurrency));
  }
}

/// Dietary indicators (vegetarian, vegan, spicy, etc.)
class _DietaryIndicators extends StatelessWidget {
  const _DietaryIndicators({required this.item});

  final MenuItemData item;

  @override
  Widget build(BuildContext context) => Row(
      children: [
        if (item.isVegetarian)
          const _DietaryBadge(
            icon: Icons.eco,
            color: AppColors.success,
            label: 'نباتي',
          ),
        if (item.isVegan)
          const _DietaryBadge(
            icon: Icons.grass,
            color: AppColors.success,
            label: 'حيواني',
          ),
        if (item.isSpicy)
          const _DietaryBadge(
            icon: Icons.local_fire_department,
            color: AppColors.warning,
            label: 'حار',
          ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuItemData>('item', item));
  }
}

/// Individual dietary badge
class _DietaryBadge extends StatelessWidget {
  const _DietaryBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 2.w),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ColorProperty('color', color));
    properties.add(StringProperty('label', label));
  }
}

/// Quantity selector and add to cart
class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAdd,
  });

  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Quantity controls
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray, width: 1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrease quantity
              GestureDetector(
                onTap: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: quantity > 1 ? AppColors.logoRed : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: quantity > 1 ? AppColors.white : AppColors.gray,
                    size: 16.sp,
                  ),
                ),
              ),

              // Quantity display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  quantity.toString(),
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),

              // Increase quantity
              GestureDetector(
                onTap: () => onQuantityChanged(quantity + 1),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.logoRed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Add to cart button
        SizedBox(
          width: 80.w,
          child: ModernButton.primary(
            text: 'إضافة',
            size: ButtonSize.small,
            fullWidth: true,
            onPressed: onAdd,
          ),
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('quantity', quantity));
    properties.add(ObjectFlagProperty<Function(int p1)>.has('onQuantityChanged', onQuantityChanged));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onAdd', onAdd));
  }
}

/// Customization section with options
class _CustomizationSection extends StatefulWidget {
  const _CustomizationSection({
    required this.customization,
    required this.onCustomizationChanged,
    required this.onClose,
  });

  final MenuCustomization customization;
  final Function(MenuCustomization) onCustomizationChanged;
  final VoidCallback onClose;

  @override
  State<_CustomizationSection> createState() => _CustomizationSectionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MenuCustomization>('customization', customization));
    properties.add(ObjectFlagProperty<Function(MenuCustomization p1)>.has('onCustomizationChanged', onCustomizationChanged));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onClose', onClose));
  }
}

class _CustomizationSectionState extends State<_CustomizationSection> {
  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Text(
                  'تخصيص الطلب',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlack,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Icon(
                    Icons.close,
                    color: AppColors.gray,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),

          // Size selection
          _CustomizationGroup(
            title: 'الحجم',
            child: Column(
              children: [
                _SizeOption(
                  title: 'صغير',
                  price: 0,
                  isSelected: widget.customization.size == ItemSize.small,
                  onSelected: (size) => _updateCustomization(
                    widget.customization.copyWith(size: size),
                  ),
                ),
                _SizeOption(
                  title: 'وسط',
                  price: 5,
                  isSelected: widget.customization.size == ItemSize.medium,
                  onSelected: (size) => _updateCustomization(
                    widget.customization.copyWith(size: size),
                  ),
                ),
                _SizeOption(
                  title: 'كبير',
                  price: 10,
                  isSelected: widget.customization.size == ItemSize.large,
                  onSelected: (size) => _updateCustomization(
                    widget.customization.copyWith(size: size),
                  ),
                ),
              ],
            ),
          ),

          // Add-ons
          _CustomizationGroup(
            title: 'إضافات',
            child: Column(
              children: [
                const AddonData(id: 'cheese', name: 'جبنة إضافية', description: 'إضافة جبنة شيدر', price: 5),
                const AddonData(id: 'meat', name: 'لحم إضافي', description: 'لحم بقري مفروم', price: 15),
                const AddonData(id: 'spicy', name: 'صلصة حارة', description: 'صلصة حارة خاصة', price: 3),
              ].map((addon) => _AddonOption(
                  addon: addon,
                  isSelected: widget.customization.selectedAddons.contains(addon.id),
                  onSelected: (selected) => _toggleAddon(addon.id, selected),
                )).toList(),
            ),
          ),

          // Special requests
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'طلبات خاصة...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.lightGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.logoRed, width: 2),
                ),
                contentPadding: EdgeInsets.all(AppSpacing.md),
              ),
              maxLines: 2,
              onChanged: (value) => _updateCustomization(
                widget.customization.copyWith(specialRequests: value),
              ),
            ),
          ),
        ],
      ),
    );

  void _updateCustomization(MenuCustomization customization) {
    widget.onCustomizationChanged(customization);
  }

  void _toggleAddon(String addonId, bool selected) {
    final selectedAddons = List<String>.from(widget.customization.selectedAddons);
    if (selected) {
      selectedAddons.add(addonId);
    } else {
      selectedAddons.remove(addonId);
    }
    _updateCustomization(
      widget.customization.copyWith(selectedAddons: selectedAddons),
    );
  }
}

/// Customization group wrapper
class _CustomizationGroup extends StatelessWidget {
  const _CustomizationGroup({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlack,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          child,
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

/// Size selection option
class _SizeOption extends StatelessWidget {
  const _SizeOption({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onSelected,
  });

  final String title;
  final double price;
  final bool isSelected;
  final Function(ItemSize) onSelected;

  @override
  Widget build(BuildContext context) {
    final size = _getSizeFromTitle(title);

    return GestureDetector(
      onTap: () => onSelected(size),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? AppColors.logoRed : AppColors.primaryBlack,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Text(
              price > 0 ? '+$price جنيه' : 'مجاناً',
              style: AppTypography.bodyMedium.copyWith(
                color: price > 0 ? AppColors.logoRed : AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.logoRed : AppColors.lightGray,
                  width: 2,
                ),
                color: isSelected ? AppColors.logoRed : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: AppColors.white, size: 12.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  ItemSize _getSizeFromTitle(String title) {
    switch (title) {
      case 'صغير':
        return ItemSize.small;
      case 'وسط':
        return ItemSize.medium;
      case 'كبير':
        return ItemSize.large;
      default:
        return ItemSize.medium;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DoubleProperty('price', price));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ObjectFlagProperty<Function(ItemSize p1)>.has('onSelected', onSelected));
  }
}

/// Add-on selection option
class _AddonOption extends StatelessWidget {
  const _AddonOption({
    required this.addon,
    required this.isSelected,
    required this.onSelected,
  });

  final AddonData addon;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addon.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.logoRed : AppColors.primaryBlack,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    addon.description,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),
            Text(
              '+${addon.price} جنيه',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.logoRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.logoRed : AppColors.lightGray,
                  width: 2,
                ),
                color: isSelected ? AppColors.logoRed : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: AppColors.white, size: 12.sp)
                  : null,
            ),
          ],
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AddonData>('addon', addon));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ObjectFlagProperty<Function(bool p1)>.has('onSelected', onSelected));
  }
}

/// Menu item data model
class MenuItemData {
  const MenuItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isSpicy = false,
    this.hasCustomizations = false,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isSpicy;
  final bool hasCustomizations;
}

/// Menu customization model
class MenuCustomization {
  const MenuCustomization({
    this.size = ItemSize.medium,
    this.selectedAddons = const [],
    this.specialRequests = '',
  });

  final ItemSize size;
  final List<String> selectedAddons;
  final String specialRequests;

  MenuCustomization copyWith({
    ItemSize? size,
    List<String>? selectedAddons,
    String? specialRequests,
  }) => MenuCustomization(
      size: size ?? this.size,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialRequests: specialRequests ?? this.specialRequests,
    );
}

/// Add-on data model
class AddonData {
  const AddonData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  final String id;
  final String name;
  final String description;
  final double price;
}

/// Item size enum
enum ItemSize {
  small,
  medium,
  large,
}

/// Card configuration
class CardConfig {
  const CardConfig({
    required this.imageSize,
    required this.height,
  });

  final double imageSize;
  final double height;
}

/// Menu card size variants
enum MenuCardSize {
  small,
  medium,
  large,
}