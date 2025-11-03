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
    // Register the new handler for filtering
    on<FilterProducts>(_onFilterProducts);
  }

  // Handler for FetchProducts event
  Future<void> _onFetchProducts(
      FetchProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());
    final failureOrProducts = await getAllProducts(NoParams());

    failureOrProducts.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (products) {
        // Calculate unique categories upon initial fetch
        final uniqueCategories = products.map((p) => p.category).toSet().toList();

        // Emit the loaded state with the full list as the initial filtered list
        emit(ProductLoaded(
          products: products,
          filteredProducts: products, // Initially, all products are filtered products
          uniqueCategories: uniqueCategories,
        ));
      },
    );
  }

  // Handler for FilterProducts event (NEW LOGIC)
  void _onFilterProducts(
      FilterProducts event,
      Emitter<ProductState> emit,
      ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      // 1. Start with the full, unfiltered product list
      List<Product> newFilteredList = currentState.products;

      // 2. Apply category filter
      if (event.category != null) {
        newFilteredList = newFilteredList
            .where((product) => product.category == event.category)
            .toList();
      }

      // 3. Apply search term filter (case-insensitive search on title and description)
      if (event.searchTerm.isNotEmpty) {
        final searchTermLower = event.searchTerm.toLowerCase();
        newFilteredList = newFilteredList
            .where((product) =>
        product.title.toLowerCase().contains(searchTermLower) ||
            product.description.toLowerCase().contains(searchTermLower))
            .toList();
      }

      // Emit the new state with the updated filtered list
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
      default:
        return 'Unexpected Error';
    }
  }
}