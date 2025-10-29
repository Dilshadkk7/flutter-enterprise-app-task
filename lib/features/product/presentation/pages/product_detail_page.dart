import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-detail';
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Product Image
            Center(
              child: Container(
                height: 250,
                width: 250,
                padding: const EdgeInsets.all(16),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Title
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 3. Category
            Text(
              'Category: ${product.category}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 16),

            // 4. Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            const Divider(),

            // 5. Description
            Text(
              'Product Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80), // Space for the floating button
          ],
        ),
      ),
      // 6. Add to Cart Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Dispatch AddItemToCart event to CartBloc
          context.read<CartBloc>().add(AddItemToCart(product));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.title} added to cart!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add to Cart'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}