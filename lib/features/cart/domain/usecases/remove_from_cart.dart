import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart implements UseCase<Cart, RemoveFromCartParams> {
  final CartRepository repository;
  RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(RemoveFromCartParams params) async {
    return await repository.removeProductFromCart(params.productId);
  }
}

class RemoveFromCartParams extends Equatable {
  final int productId;
  const RemoveFromCartParams({required this.productId});
  @override
  List<Object> get props => [productId];
}