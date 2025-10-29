import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/core/config/app_theme.dart';
import 'package:flutter_enterprise_app/core/di/service_locator.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_enterprise_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_enterprise_app/features/product/presentation/pages/product_detail_page.dart';
import 'package:flutter_enterprise_app/features/product/presentation/pages/product_list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductBloc>()..add(FetchProducts()),
        ),
        BlocProvider(
          create: (_) => sl<CartBloc>()..add(LoadCart()),
        ),
      ],
      child: MaterialApp(
        title: 'Enterprise App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: ProductListPage.routeName,

        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ProductListPage.routeName:
              return MaterialPageRoute(builder: (_) => const ProductListPage());

            case CartPage.routeName:
              return MaterialPageRoute(builder: (_) => const CartPage());

            case ProductDetailPage.routeName:
            // Cast the arguments back to the Product entity
              final product = settings.arguments as Product;
              return MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              );

            default:
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}