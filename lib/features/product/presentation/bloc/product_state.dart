part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;
  final Failure failure;

  const ProductError({required this.message, required this.failure});

  @override
  List<Object> get props => [message, failure];
}

class ProductLoaded extends ProductState {
  final List<Product> products;           // The original, full list of products
  final List<Product> filteredProducts;   // The list currently displayed in the UI
  final List<String> uniqueCategories;    // All categories found in the original list

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    required this.uniqueCategories,
  });

  @override
  List<Object> get props => [products, filteredProducts, uniqueCategories];
}