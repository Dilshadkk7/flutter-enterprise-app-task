import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/repositories/product_repository.dart';

// Repository implementation [cite: 26]
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  // TODO: Add a NetworkInfo service to check connectivity

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    // For this task, we will always fetch from remote and then cache.
    // A production app would check connectivity first.
    try {
      final remoteProducts = await remoteDataSource.getAllProducts();
      await localDataSource.cacheProducts(remoteProducts); // Cache products [cite: 30]
      return Right(remoteProducts);
    } catch (e) {
      // If remote fails, try to load from cache
      try {
        final localProducts = await localDataSource.getLastProducts();
        if (localProducts.isNotEmpty) {
          return Right(localProducts);
        } else {
          return Left(CacheFailure()); // No cache available
        }
      } catch (cacheError) {
        return Left(CacheFailure());
      }
    }
  }
}