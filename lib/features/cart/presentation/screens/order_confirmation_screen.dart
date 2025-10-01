import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/providers.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final subtotal = cartNotifier.subtotal;
    final deliveryFee = cartNotifier.deliveryFee;
    final discount = cartNotifier.discount;
    final total = cartNotifier.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            fontFamily: 'TutanoCCV2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2B3A67),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, size: 80.sp, color: Colors.green),
            SizedBox(height: 16.h),
            Text(
              'Order Placed!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B3A67),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your order has been confirmed. Estimated delivery time: 30-45 minutes.',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            ...cartState.map(
              (item) => ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: Text(item.name),
                subtitle: Text(
                  '${item.quantity}x \$${item.price.toStringAsFixed(2)}',
                ),
                trailing: Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Fee'),
                Text('\$${deliveryFee.toStringAsFixed(2)}'),
              ],
            ),
            if (discount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount'),
                  Text('- \$${discount.toStringAsFixed(2)}'),
                ],
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            const Text(
              'Tracking',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            const LinearProgressIndicator(value: 0.3),
            SizedBox(height: 8.h),
            const Text('Preparing your order...'),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to tracking screen
                  cartNotifier.clearCart();
                  Navigator.pop(context);
                },
                child: const Text('Track Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84545),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
