import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/egyptian_currency_service.dart';

/// Widget for displaying Egyptian currency with proper formatting
class EgyptianCurrencyDisplay extends StatelessWidget {

  const EgyptianCurrencyDisplay({
    required this.amount, super.key,
    this.style,
    this.useArabicNumerals = true,
    this.compact = false,
    this.showPriceCategory = false,
    this.size,
  });
  final double amount;
  final TextStyle? style;
  final bool useArabicNumerals;
  final bool compact;
  final bool showPriceCategory;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: size ?? 14.sp,
      fontWeight: FontWeight.bold,
      color: _getPriceColor(),
      fontFamily: 'Cairo',
    );

    String displayText;
    if (compact) {
      displayText = amount.toEGPCompact(useArabicNumerals: useArabicNumerals);
    } else {
      displayText = amount.toEGP(useArabicNumerals: useArabicNumerals);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayText,
          style: style ?? defaultStyle,
        ),
        if (showPriceCategory) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _getPriceCategoryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              amount.getPriceCategoryInEgypt(useArabicNumerals: useArabicNumerals),
              style: TextStyle(
                fontSize: 10.sp,
                color: _getPriceCategoryColor(),
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getPriceColor() {
    if (amount.isExpensiveInEgypt) {
      return const Color(0xFFDC2626); // Red for expensive
    } else if (amount.isBudgetFriendlyInEgypt) {
      return const Color(0xFF059669); // Green for budget-friendly
    } else {
      return const Color(0xFF1F2937); // Gray for moderate
    }
  }

  Color _getPriceCategoryColor() {
    if (amount.isExpensiveInEgypt) {
      return const Color(0xFFDC2626); // Red for expensive
    } else if (amount.isBudgetFriendlyInEgypt) {
      return const Color(0xFF059669); // Green for budget-friendly
    } else {
      return const Color(0xFF6B7280); // Gray for moderate
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('amount', amount));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('useArabicNumerals', useArabicNumerals));
    properties.add(DiagnosticsProperty<bool>('compact', compact));
    properties.add(DiagnosticsProperty<bool>('showPriceCategory', showPriceCategory));
    properties.add(DoubleProperty('size', size));
  }
}

/// Widget for displaying price range (for restaurants)
class PriceRangeDisplay extends StatelessWidget {

  const PriceRangeDisplay({
    required this.minPrice, required this.maxPrice, super.key,
    this.style,
    this.useArabicNumerals = true,
  });
  final double minPrice;
  final double maxPrice;
  final TextStyle? style;
  final bool useArabicNumerals;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 12.sp,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontFamily: 'Cairo',
    );

    final displayText = EgyptianCurrencyService.formatPriceRange(
      minPrice,
      maxPrice,
      useArabicNumerals: useArabicNumerals,
    );

    return Text(
      displayText,
      style: style ?? defaultStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minPrice', minPrice));
    properties.add(DoubleProperty('maxPrice', maxPrice));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('useArabicNumerals', useArabicNumerals));
  }
}

/// Widget for displaying delivery fee with Egyptian context
class DeliveryFeeDisplay extends StatelessWidget {

  const DeliveryFeeDisplay({
    required this.fee, super.key,
    this.style,
    this.useArabicNumerals = true,
  });
  final double fee;
  final TextStyle? style;
  final bool useArabicNumerals;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 12.sp,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontFamily: 'Cairo',
    );

    final displayText = EgyptianCurrencyService.formatDeliveryFee(
      fee,
      useArabicNumerals: useArabicNumerals,
    );

    return Row(
      children: [
        Icon(
          fee == 0 ? Icons.local_shipping : Icons.local_shipping,
          size: 14.sp,
          color: fee == 0 ? const Color(0xFF059669) : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 4.w),
        Text(
          displayText,
          style: style ?? defaultStyle,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('fee', fee));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('useArabicNumerals', useArabicNumerals));
  }
}

/// Widget for displaying order total with breakdown
class OrderTotalDisplay extends StatelessWidget {

  const OrderTotalDisplay({
    required this.subtotal, required this.deliveryFee, required this.tax, super.key,
    this.style,
    this.useArabicNumerals = true,
  });
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final TextStyle? style;
  final bool useArabicNumerals;

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee + tax;
    final defaultStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Cairo',
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Subtotal
          _buildPriceRow(
            useArabicNumerals ? 'المجموع الفرعي' : 'Subtotal',
            subtotal,
            style ?? defaultStyle,
            useArabicNumerals,
          ),

          SizedBox(height: 8.h),

          // Delivery Fee
          _buildPriceRow(
            useArabicNumerals ? 'رسوم التوصيل' : 'Delivery Fee',
            deliveryFee,
            TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'Cairo',
            ),
            useArabicNumerals,
          ),

          SizedBox(height: 4.h),

          // Tax
          _buildPriceRow(
            useArabicNumerals ? 'الضريبة' : 'Tax',
            tax,
            TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'Cairo',
            ),
            useArabicNumerals,
          ),

          SizedBox(height: 12.h),

          // Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            height: 1.h,
          ),

          SizedBox(height: 12.h),

          // Total
          _buildPriceRow(
            useArabicNumerals ? 'الإجمالي' : 'Total',
            total,
            TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cairo',
            ),
            useArabicNumerals,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, TextStyle style, bool useArabicNumerals) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style.copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          amount.toEGP(useArabicNumerals: useArabicNumerals),
          style: style,
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('subtotal', subtotal));
    properties.add(DoubleProperty('deliveryFee', deliveryFee));
    properties.add(DoubleProperty('tax', tax));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('useArabicNumerals', useArabicNumerals));
  }
}

/// Widget for currency converter (for international users)
class CurrencyConverterWidget extends StatefulWidget {

  const CurrencyConverterWidget({
    required this.amountInEGP, super.key,
    this.onCurrencyChanged,
  });
  final double amountInEGP;
  final Function(double)? onCurrencyChanged;

  @override
  State<CurrencyConverterWidget> createState() => _CurrencyConverterWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('amountInEGP', amountInEGP));
    properties.add(ObjectFlagProperty<Function(double p1)?>.has('onCurrencyChanged', onCurrencyChanged));
  }
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  String _selectedCurrency = 'EGP';

  @override
  Widget build(BuildContext context) {
    final currencies = ['EGP', 'USD', 'EUR', 'SAR', 'AED'];
    final currencySymbols = {
      'EGP': 'ج.م',
      'USD': r'$',
      'EUR': '€',
      'SAR': 'ر.س',
      'AED': 'د.إ',
    };

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحويل العملة',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  children: currencies.map((currency) {
                    final isSelected = _selectedCurrency == currency;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCurrency = currency);
                        widget.onCurrencyChanged?.call(_convertAmount(widget.amountInEGP, currency));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          currencySymbols[currency]!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _getConvertedAmountText(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  String _getConvertedAmountText() {
    switch (_selectedCurrency) {
      case 'USD':
        return EgyptianCurrencyService.formatWithExchangeRate(
          widget.amountInEGP,
          'USD',
          useArabicNumerals: true,
        );
      case 'EUR':
        return EgyptianCurrencyService.formatWithExchangeRate(
          widget.amountInEGP,
          'EUR',
          useArabicNumerals: true,
        );
      case 'SAR':
        return EgyptianCurrencyService.formatWithExchangeRate(
          widget.amountInEGP,
          'SAR',
          useArabicNumerals: true,
        );
      case 'AED':
        return EgyptianCurrencyService.formatWithExchangeRate(
          widget.amountInEGP,
          'AED',
          useArabicNumerals: true,
        );
      default:
        return widget.amountInEGP.toEGP(useArabicNumerals: true);
    }
  }

  double _convertAmount(double amountInEGP, String targetCurrency) {
    switch (targetCurrency) {
      case 'USD':
        return EgyptianCurrencyService.egpToUSD(amountInEGP);
      case 'EUR':
        return EgyptianCurrencyService.egpToEUR(amountInEGP);
      case 'SAR':
        return EgyptianCurrencyService.egpToSAR(amountInEGP);
      case 'AED':
        return EgyptianCurrencyService.egpToAED(amountInEGP);
      default:
        return amountInEGP;
    }
  }
}