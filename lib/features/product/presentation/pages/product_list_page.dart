import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_enterprise_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_enterprise_app/features/product/presentation/widgets/product_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductListPage extends StatelessWidget {
  static const routeName = '/';
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          _CartIconBadge(),
        ],
      ),
      body: Column(
        children: [
          _SearchAndFilterBar(),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  // Display a spinning loader during data fetch
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }
                if (state is ProductError) {
                  // Display error message with a retry button
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(FetchProducts());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ProductLoaded) {
                  if (state.displayedProducts.isEmpty) {
                    return const Center(child: Text('No products found matching your criteria.'));
                  }
                  // Product grid display
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7, // Adjust aspect ratio for better display
                    ),
                    itemCount: state.displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.displayedProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () {
                          // Dispatch AddToCart event to CartBloc
                          context.read<CartBloc>().add(AddItemToCart(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Search and Filter functionality
class _SearchAndFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is! ProductLoaded) return const SizedBox.shrink();

        // Ensure 'All' is the first option
        final categories = {'All', ...state.categories};

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Search Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products by name...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                ),
                onChanged: (query) {
                  context.read<ProductBloc>().add(SearchProducts(query));
                },
              ),
              const SizedBox(height: 8),
              // Category Filter Dropdown
              DropdownButtonFormField<String>(
                value: state.selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<ProductBloc>().add(FilterProducts(newValue));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget for Cart Icon with Badge
class _CartIconBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        // Check loaded state to get cart item count
        if (state is CartLoaded) {
          itemCount = state.cart.totalItems;
        }

        return IconButton(
          onPressed: () {
            Navigator.pushNamed(context, CartPage.routeName);
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart),
              if (itemCount > 0)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}