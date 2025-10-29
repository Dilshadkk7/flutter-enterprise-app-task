part of 'product_bloc.dart';

// Events for the ProductBloc [cite: 27]
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object> get props => [query];
}

class FilterProducts extends ProductEvent {
  final String category;
  const FilterProducts(this.category);
  @override
  List<Object> get props => [category];
}