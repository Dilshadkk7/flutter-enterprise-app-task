import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_enterprise_app/features/product/presentation/widgets/product_card.dart';
import 'package:flutter_enterprise_app/features/product/presentation/widgets/search_filter_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductListPage extends StatefulWidget {
  static const routeName = '/product-list';

  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  // Function to disable back navigation
  // Returning 'false' means the route will not be popped.
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Ensures the back gesture/button is disabled
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Catalog'),
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                int itemCount = 0;
                if (state is CartLoaded) {
                  itemCount = state.cart.totalItems;
                }
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartPage.routeName);
                      },
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SearchFilterBar(),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).primaryColor,
                        size: 50.0,
                      ),
                    );
                  } else if (state is ProductLoaded) {
                    final products = state.filteredProducts;
                    if (products.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: () {
                            context.read<CartBloc>().add(AddItemToCart(product));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart.'),
                                duration: const Duration(milliseconds: 700),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Text('Error: ${state.message}'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}