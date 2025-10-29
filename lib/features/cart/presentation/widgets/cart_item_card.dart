import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Price
                  Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: item.quantity > 1 ? () => onUpdateQuantity(item.quantity - 1) : null,
                  color: item.quantity > 1 ? Theme.of(context).primaryColor : Colors.grey,
                ),
                Text(item.quantity.toString(), style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => onUpdateQuantity(item.quantity + 1),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            // Remove button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}