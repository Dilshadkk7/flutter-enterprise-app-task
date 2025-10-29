import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

// Abstract contract for the repository [cite: 26]
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
}