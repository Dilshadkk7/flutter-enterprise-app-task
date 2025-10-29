part of 'product_bloc.dart';

// States for the ProductBloc [cite: 27]
abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {} // Loading state [cite: 15]

class ProductError extends ProductState { // Error state [cite: 15]
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}

class ProductLoaded extends ProductState {
  final List<Product> allProducts; // Master list
  final List<Product> displayedProducts; // List after filter/search [cite: 14]
  final Set<String> categories;
  final String selectedCategory;
  final String searchQuery;

  const ProductLoaded({
    required this.allProducts,
    required this.displayedProducts,
    required this.categories,
    required this.selectedCategory,
    this.searchQuery = '',
  });

  ProductLoaded copyWith({
    List<Product>? displayedProducts,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductLoaded(
      allProducts: allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      categories: categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [displayedProducts, selectedCategory, searchQuery];
}