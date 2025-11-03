import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/network/network_info.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } catch (e) {
        // Server failure or other unexpected error
        return Left(ServerFailure());
      }
    } else {
      // No internet connection
      try {
        final localProducts = await localDataSource.getLastProducts();
        if (localProducts.isNotEmpty) {
          return Right(localProducts);
        } else {
          // Offline but no data in cache
          return Left(NetworkFailure());
        }
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}
