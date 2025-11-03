part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {}

// Used by the search and filter bar
class FilterProducts extends ProductEvent {
  final String searchTerm;
  final String? category;

  const FilterProducts({required this.searchTerm, this.category});

  @override
  List<Object?> get props => [searchTerm, category];
}