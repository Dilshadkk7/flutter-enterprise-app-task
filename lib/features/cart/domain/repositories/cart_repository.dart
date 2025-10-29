import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

// Abstract contract for Cart operations [cite: 26]
abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addProductToCart(Product product);
  Future<Either<Failure, Cart>> removeProductFromCart(int productId);
  Future<Either<Failure, Cart>> updateProductQuantity(int productId, int quantity);
  Future<Either<Failure, void>> placeOrder();
}