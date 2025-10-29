import 'package:dio/dio.dart';
import 'package:flutter_enterprise_app/core/network/api_client.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
}

// Fetches product data from the FakeStore API [cite: 12]
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await client.get('/products');
      return (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException {
      throw Exception('Failed to fetch products'); // Or a custom ServerException
    }
  }
}