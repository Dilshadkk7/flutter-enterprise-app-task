part of 'cart_bloc.dart'; // ⬅️ Must be the first line

abstract class CartState extends Equatable { const CartState(); @override List<Object> get props => []; }
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override List<Object> get props => [message];
}
class CartOrderSuccess extends CartState {} // For showing success message
class CartLoaded extends CartState {
  final Cart cart;
  const CartLoaded(this.cart);
  @override List<Object> get props => [cart];
}