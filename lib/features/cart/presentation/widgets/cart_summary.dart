import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartSummary extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPlaceOrder;

  const CartSummary({
    super.key,
    required this.totalPrice,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(0),
      // Styling for a prominent bottom bar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                )
                    .animate()
                    .fade(duration: const Duration(milliseconds: 300))
                    .scale() // Animate the text on changes
              ],
            ),
            const SizedBox(height: 16),
            // Primary Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: onPlaceOrder,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slide(
          begin: const Offset(0, 1),
          end: Offset.zero,
          duration: const Duration(milliseconds: 400), // Slide up from the bottom
        )
        .fadeIn();
  }
}
