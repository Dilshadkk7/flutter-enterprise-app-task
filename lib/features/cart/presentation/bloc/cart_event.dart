part of 'cart_bloc.dart'; // ⬅️ Must be the first line

abstract class CartEvent extends Equatable { const CartEvent(); @override List<Object> get props => []; }
class LoadCart extends CartEvent {}
class AddItemToCart extends CartEvent {
  final Product product;
  const AddItemToCart(this.product);
  @override List<Object> get props => [product];
}
class RemoveItemFromCart extends CartEvent {
  final int productId;
  const RemoveItemFromCart(this.productId);
  @override List<Object> get props => [productId];
}
class UpdateItemQuantity extends CartEvent {
  final int productId;
  final int quantity;
  const UpdateItemQuantity(this.productId, this.quantity);
  @override List<Object> get props => [productId, quantity];
}
class PlaceOrderEvent extends CartEvent {}