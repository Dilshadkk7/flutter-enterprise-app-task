import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_enterprise_app/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

// Repository implementation for Cart [cite: 26]
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(Cart(items: items));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> addProductToCart(Product product) async {
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
      return Right(Cart(items: items));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> removeProductFromCart(int productId) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((item) => item.product.id == productId); //
      await localDataSource.saveCartItems(items);
      return Right(Cart(items: items));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> updateProductQuantity(int productId, int quantity) async {
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
        return Right(Cart(items: items));
      }
      return Left(CacheFailure()); // Item not found
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> placeOrder() async {
    // This is a mock order success
    try {
      // In a real app, this would call a remote data source.
      // For this task, we just clear the local cart.
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}