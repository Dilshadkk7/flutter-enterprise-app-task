import 'package:dio/dio.dart';
import 'package:flutter_enterprise_app/core/network/api_client.dart';
import 'package:flutter_enterprise_app/core/persistence/hive_service.dart';
import 'package:flutter_enterprise_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_enterprise_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/add_to_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/get_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/place_order.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/order/data/datasources/order_local_data_source.dart';
import 'package:flutter_enterprise_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:flutter_enterprise_app/features/order/domain/repositories/order_repository.dart';
import 'package:flutter_enterprise_app/features/order/domain/usecases/get_orders.dart';
import 'package:flutter_enterprise_app/features/order/presentation/bloc/order_history_bloc.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:flutter_enterprise_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:flutter_enterprise_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_enterprise_app/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_enterprise_app/features/product/domain/usecases/get_all_products.dart';
import 'package:flutter_enterprise_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl = Service Locator

// Registers dependencies using get_it [cite: 28]
Future<void> init() async {
  // Blocs
  sl.registerFactory(() => ProductBloc(getAllProducts: sl()));
  sl.registerFactory(() => CartBloc(
    getCart: sl(),
    addToCart: sl(),
    removeFromCart: sl(),
    updateCartQuantity: sl(),
    placeOrder: sl(),
  ));
  sl.registerFactory(() => OrderHistoryBloc(getOrders: sl()));

  // Use Cases (Domain Layer)
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantity(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));

  // Repositories (Data Layer)
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(localDataSource: sl(), orderLocalDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
        () => OrderRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources (Data Layer)
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(hiveService: sl()),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(hiveService: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
        () => OrderLocalDataSourceImpl(hiveService: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(Dio())); // Registers Dio client
  sl.registerLazySingleton(() => HiveService());
}