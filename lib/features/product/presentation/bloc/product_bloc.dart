import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:flutter_enterprise_app/features/product/domain/usecases/get_all_products.dart';

part 'product_event.dart';
part 'product_state.dart';

// Product Bloc for state management [cite: 27]
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  List<Product> _allProducts = [];

  ProductBloc({required this.getAllProducts}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await getAllProducts(NoParams());
    failureOrProducts.fold(
          (failure) => emit(ProductError('Failed to fetch products')),
          (products) {
        _allProducts = products;
        final categories = products.map((p) => p.category).toSet();
        emit(ProductLoaded(
          allProducts: _allProducts,
          displayedProducts: _allProducts,
          categories: categories,
          selectedCategory: 'All',
        ));
      },
    );
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredList = _filterAndSearch(
        query: event.query,
        category: currentState.selectedCategory,
      );
      emit(currentState.copyWith(
        displayedProducts: filteredList,
        searchQuery: event.query,
      ));
    }
  }

  void _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredList = _filterAndSearch(
        query: currentState.searchQuery,
        category: event.category,
      );
      emit(currentState.copyWith(
        displayedProducts: filteredList,
        selectedCategory: event.category,
      ));
    }
  }

  // Logic for search and filter [cite: 14]
  List<Product> _filterAndSearch({String? query, String? category}) {
    List<Product> products = _allProducts;

    if (category != null && category != 'All') {
      products = products.where((p) => p.category == category).toList();
    }

    if (query != null && query.isNotEmpty) {
      products = products.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return products;
  }
}