import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_enterprise_app/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_enterprise_app/features/order/data/datasources/order_local_data_source.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final OrderLocalDataSource orderLocalDataSource;

  CartRepositoryImpl({
    required this.localDataSource,
    required this.orderLocalDataSource,
  });

  @override
  Future<dartz.Either<Failure, Cart>> getCart() async {
    try {
      final items = await localDataSource.getCartItems();
      return dartz.Right(Cart(items: items));
    } catch (e) {
      return dartz.Left(CacheFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Cart>> addProductToCart(Product product) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == product.id);

      if (index != -1) {
        // Item already exists, update quantity
        final existingItem = items[index];
        items[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      } else {
        // Add new item
        items.add(CartItemModel(product: product as ProductModel, quantity: 1));
      }

      await localDataSource.saveCartItems(items);
      return dartz.Right(Cart(items: items));
    } catch (e) {
      return dartz.Left(CacheFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Cart>> removeProductFromCart(int productId) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((item) => item.product.id == productId); //
      await localDataSource.saveCartItems(items);
      return dartz.Right(Cart(items: items));
    } catch (e) {
      return dartz.Left(CacheFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Cart>> updateProductQuantity(int productId, int quantity) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == productId);

      if (index != -1) {
        if (quantity > 0) {
          items[index] = items[index].copyWith(quantity: quantity); //
        } else {
          // Remove if quantity is 0 or less
          items.removeAt(index);
        }
        await localDataSource.saveCartItems(items);
        return dartz.Right(Cart(items: items));
      }
      return dartz.Left(CacheFailure()); // Item not found
    } catch (e) {
      return dartz.Left(CacheFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, void>> placeOrder() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      if (cartItems.isEmpty) {
        return dartz.Left(CacheFailure(message: 'Cart is empty'));
      }

      final products = cartItems.map((item) => item.product).toList();
      final totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

      final order = Order(
        items: products,
        totalPrice: totalPrice,
        orderDate: DateTime.now(),
      );

      await orderLocalDataSource.saveOrder(order);
      await localDataSource.clearCart();

      return dartz.Right(null);
    } catch (e) {
      return dartz.Left(CacheFailure());
    }
  }
}
