import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/usecases/get_all_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;

  ProductBloc({required this.getAllProducts}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FilterProducts>(_onFilterProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final failureOrProducts = await getAllProducts(NoParams());

    failureOrProducts.fold(
      (failure) => emit(ProductError(
        message: _mapFailureToMessage(failure),
        failure: failure,
      )),
      (products) {
        final uniqueCategories = products.map((p) => p.category).toSet().toList();
        emit(ProductLoaded(
          products: products,
          filteredProducts: products,
          uniqueCategories: uniqueCategories,
        ));
      },
    );
  }

  void _onFilterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      List<Product> newFilteredList = currentState.products;

      if (event.category != null) {
        newFilteredList = newFilteredList
            .where((product) => product.category == event.category)
            .toList();
      }

      if (event.searchTerm.isNotEmpty) {
        final searchTermLower = event.searchTerm.toLowerCase();
        newFilteredList = newFilteredList
            .where((product) =>
                product.title.toLowerCase().contains(searchTermLower) ||
                product.description.toLowerCase().contains(searchTermLower))
            .toList();
      }

      emit(ProductLoaded(
        products: currentState.products,
        filteredProducts: newFilteredList,
        uniqueCategories: currentState.uniqueCategories,
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error. Please try again.';
      case CacheFailure:
        return 'Could not load data from cache.';
      case NetworkFailure:
        return 'No Internet Connection.';
      default:
        return 'Unexpected Error';
    }
  }
}
