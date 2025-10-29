import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image (Flexible space)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain, // Use contain to respect original aspect ratio
                placeholder: (context, url) => Center(
                  child: SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.title,
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Category
                Text(
                  product.category,
                  style: textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Price and Add to Cart Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: onAddToCart,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}