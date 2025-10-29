import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/repositories/product_repository.dart';

// Use case for fetching products [cite: 26]
class GetAllProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}