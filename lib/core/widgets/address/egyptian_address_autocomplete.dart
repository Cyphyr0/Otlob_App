import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../services/egyptian_address_service.dart';
import '../../../utils/localization_helper.dart';

/// Egyptian address autocomplete widget
class EgyptianAddressAutocomplete extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Function(EgyptianAddress)? onAddressSelected;
  final EgyptianAddress? initialAddress;
  final bool enabled;
  final bool showSpecialInstructions;

  const EgyptianAddressAutocomplete({
    super.key,
    this.label = 'العنوان',
    this.hint = 'ابحث عن المحافظة أو المدينة أو الحي',
    this.controller,
    this.onAddressSelected,
    this.initialAddress,
    this.enabled = true,
    this.showSpecialInstructions = true,
  });

  @override
  State<EgyptianAddressAutocomplete> createState() => _EgyptianAddressAutocompleteState();
}

class _EgyptianAddressAutocompleteState extends State<EgyptianAddressAutocomplete> {
  late TextEditingController _searchController;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();

  EgyptianGovernorate? _selectedGovernorate;
  District? _selectedDistrict;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();

    if (widget.initialAddress != null) {
      _initializeWithAddress(widget.initialAddress!);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _phoneController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  void _initializeWithAddress(EgyptianAddress address) {
    _searchController.text = address.formattedAddress;
    _streetController.text = address.street;
    _buildingController.text = address.building;
    _floorController.text = address.floor;
    _apartmentController.text = address.apartment;
    _phoneController.text = address.phone;
    _specialInstructionsController.text = address.specialInstructions;

    // Find and set governorate and district
    _selectedGovernorate = EgyptianAddressService.getGovernorateByName(address.governorate);
    if (_selectedGovernorate != null) {
      _selectedDistrict = _selectedGovernorate!.districts
          .where((district) => district.name == address.district)
          .firstOrNull;
    }
    _selectedCity = address.city;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location search autocomplete
        _buildLocationSearch(),

        SizedBox(height: 16.h),

        // Address details form
        _buildAddressForm(),

        if (widget.showSpecialInstructions) ...[
          SizedBox(height: 16.h),
          _buildSpecialInstructions(),
        ],
      ],
    );
  }

  Widget _buildLocationSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TypeAheadFormField<AddressSearchResult>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _searchController,
            enabled: widget.enabled,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
              prefixIcon: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: widget.enabled
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.length < 2) return [];
            await EgyptianAddressService.initialize();
            return EgyptianAddressService.searchAddresses(pattern);
          },
          itemBuilder: (context, AddressSearchResult suggestion) {
            return ListTile(
              leading: Icon(
                suggestion.type == AddressType.governorate
                    ? Icons.location_city
                    : Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
              title: Text(
                suggestion.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
              ),
              subtitle: Text(
                suggestion.type == AddressType.governorate
                    ? 'محافظة'
                    : 'حي',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            );
          },
          onSuggestionSelected: (AddressSearchResult suggestion) {
            setState(() {
              if (suggestion.type == AddressType.governorate) {
                _selectedGovernorate = suggestion.governorate;
                _selectedDistrict = null;
                _searchController.text = suggestion.governorate!.name;
              } else {
                _selectedGovernorate = suggestion.governorate;
                _selectedDistrict = suggestion.district;
                _searchController.text = '${suggestion.governorate!.name} - ${suggestion.district!.name}';
              }
            });
          },
          noItemsFoundBuilder: (context) => Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressForm() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل العنوان',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 12.h),

          // Governorate and City row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المحافظة',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _selectedGovernorate?.name ?? 'اختر المحافظة',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: _selectedGovernorate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المدينة',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TextField(
                      controller: TextEditingController(text: _selectedCity),
                      enabled: widget.enabled,
                      onChanged: (value) => _selectedCity = value,
                      decoration: InputDecoration(
                        hintText: 'مثال: القاهرة',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: 'Cairo',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Street and Building row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _streetController,
                  label: 'الشارع',
                  hint: 'مثال: شارع التحرير',
                  enabled: widget.enabled,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  controller: _buildingController,
                  label: 'المبنى',
                  hint: 'مثال: 15',
                  enabled: widget.enabled,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Floor and Apartment row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _floorController,
                  label: 'الدور (اختياري)',
                  hint: 'مثال: الدور الثالث',
                  enabled: widget.enabled,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  controller: _apartmentController,
                  label: 'الشقة (اختياري)',
                  hint: 'مثال: شقة 5',
                  enabled: widget.enabled,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Phone number
          _buildTextField(
            controller: _phoneController,
            label: 'رقم الهاتف (اختياري)',
            hint: 'مثال: 01112345678',
            enabled: widget.enabled,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 4.h),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'Cairo',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          ),
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تعليمات خاصة للتوصيل (اختياري)',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _specialInstructionsController,
          enabled: widget.enabled,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'مثال: الجرس لا يعمل، رن مرتين',
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'Cairo',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: widget.enabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  /// Get the current address from form fields
  EgyptianAddress getCurrentAddress() {
    return EgyptianAddress(
      governorate: _selectedGovernorate?.name ?? '',
      city: _selectedCity ?? '',
      district: _selectedDistrict?.name ?? '',
      street: _streetController.text,
      building: _buildingController.text,
      floor: _floorController.text,
      apartment: _apartmentController.text,
      phone: _phoneController.text,
      specialInstructions: _specialInstructionsController.text,
    );
  }

  /// Validate the current address
  AddressValidationResult validateCurrentAddress() {
    return EgyptianAddressService.validateAddress(getCurrentAddress());
  }
}