import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantity implements UseCase<Cart, UpdateCartQuantityParams> {
  final CartRepository repository;
  UpdateCartQuantity(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateCartQuantityParams params) async {
    return await repository.updateProductQuantity(params.productId, params.quantity);
  }
}

class UpdateCartQuantityParams extends Equatable {
  final int productId;
  final int quantity;
  const UpdateCartQuantityParams({required this.productId, required this.quantity});
  @override
  List<Object> get props => [productId, quantity];
}