import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/repositories/product_repository.dart';

// Repository implementation that decides where to get the data from.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      // 1. Attempt to fetch data from the remote source (FakeStore API)
      final remoteProducts = await remoteDataSource.getAllProducts();

      // 2. If successful, cache the new data locally for offline use
      await localDataSource.cacheProducts(remoteProducts);

      // 3. Return the data
      return Right(remoteProducts);

    } catch (e) {
      // If remote fetching fails (e.g., network error)
      try {
        // 4. Attempt to load data from the local cache (Hive)
        final localProducts = await localDataSource.getLastProducts();

        if (localProducts.isNotEmpty) {
          // 5. If cache is not empty, return the cached data
          return Right(localProducts);
        } else {
          // 6. If cache is also empty, return a CacheFailure (or ServerFailure if you want to emphasize the source of the original error)
          return Left(CacheFailure());
        }
      } catch (cacheError) {
        // Fallback if reading the cache itself fails
        return Left(CacheFailure());
      }
    }
  }
}