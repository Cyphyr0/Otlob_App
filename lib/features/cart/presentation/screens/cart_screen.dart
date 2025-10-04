import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/features/cart/presentation/providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? selectedPayment = 'cash';
  final TextEditingController promoController = TextEditingController();

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartState.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Cart',
            style: TextStyle(
              fontFamily: 'TutanoCCV2',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF2B3A67),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 100.sp,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B3A67),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Start shopping to add items',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84545),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                ),
                child: const Text('Start Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(
            fontFamily: 'TutanoCCV2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B3A67),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: cartState.length,
              itemBuilder: (context, index) {
                final item = cartState[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            width: 80.w,
                            height: 80.h,
                            color: Colors.grey[300],
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.image_not_supported,
                                            ),
                                  )
                                : const Icon(Icons.restaurant_menu),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF2B3A67),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => cartNotifier.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              ),
                              icon: const Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () => cartNotifier.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              ),
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            IconButton(
                              onPressed: () => cartNotifier.removeItem(item.id),
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red[100],
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text(
                      '\$${cartNotifier.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Fee'),
                    Text('\$${cartNotifier.deliveryFee.toStringAsFixed(2)}'),
                  ],
                ),
                if (cartNotifier.hasValidPromo) ...[
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount'),
                      Text(
                        '- \$${cartNotifier.discount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cartNotifier.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Promo Code
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: promoController,
                        decoration: const InputDecoration(
                          labelText: 'Promo Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: () {
                        final code = promoController.text.trim();
                        if (code.isNotEmpty) {
                          cartNotifier.applyPromo(code);
                          if (cartNotifier.promoError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(cartNotifier.promoError!)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Promo applied!')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B3A67),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
                if (cartNotifier.hasValidPromo) ...[
                  SizedBox(height: 8.h),
                  Text(
                    '10% off applied!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                // Payment Options
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RadioGroup<String>(
                  groupValue: selectedPayment,
                  onChanged: (value) => setState(() => selectedPayment = value),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Cash on Delivery'),
                        value: 'cash',
                      ),
                      RadioListTile<String>(
                        title: const Text('Card'),
                        value: 'card',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/order-confirmation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE84545),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
