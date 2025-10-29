import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

class AddToCart implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;
  AddToCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addProductToCart(params.product);
  }
}

class AddToCartParams extends Equatable {
  final Product product;
  const AddToCartParams({required this.product});
  @override
  List<Object> get props => [product];
}