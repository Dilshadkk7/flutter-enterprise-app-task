import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart (Order Dashboard)'),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        // Listener is used for non-UI changes like showing success messages
        listener: (context, state) {
          if (state is CartOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // Builder is used for UI changes
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          if (state is CartError) {
            return Center(child: Text(state.message));
          }
          if (state is CartLoaded) {
            if (state.cart.items.isEmpty) {
              return const Center(
                child: Text('Your cart is empty. Start shopping!'),
              );
            }
            // Display cart items
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.cart.items.length,
                    itemBuilder: (context, index) {
                      final item = state.cart.items[index];
                      return CartItemCard(
                        item: item,
                        onRemove: () { // Dispatch remove event
                          context.read<CartBloc>().add(RemoveItemFromCart(item.product.id));
                        },
                        onUpdateQuantity: (newQuantity) { // Dispatch update quantity event
                          context.read<CartBloc>().add(UpdateItemQuantity(item.product.id, newQuantity));
                        },
                      );
                    },
                  ),
                ),
                // Show total price and place order button
                CartSummary(
                  totalPrice: state.cart.totalPrice,
                  onPlaceOrder: () {
                    context.read<CartBloc>().add(PlaceOrderEvent());
                  },
                )
              ],
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}