import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/add_to_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/get_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/place_order.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

part 'cart_event.dart'; // ⬅️ Must be here
part 'cart_state.dart';  // ⬅️ Must be here

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartQuantity updateCartQuantity;
  final PlaceOrder placeOrder;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
    required this.placeOrder,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final failureOrCart = await getCart(NoParams());
    failureOrCart.fold(
          (failure) => emit(const CartError('Failed to load cart.')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
    final failureOrCart = await addToCart(AddToCartParams(product: event.product));
    failureOrCart.fold(
          (failure) => emit(const CartError('Failed to add item.')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) async {
    final failureOrCart = await removeFromCart(RemoveFromCartParams(productId: event.productId));
    failureOrCart.fold(
          (failure) => emit(const CartError('Failed to remove item.')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<CartState> emit) async {
    final failureOrCart = await updateCartQuantity(UpdateCartQuantityParams(
      productId: event.productId,
      quantity: event.quantity,
    ));
    failureOrCart.fold(
          (failure) => emit(const CartError('Failed to update quantity.')),
          (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<CartState> emit) async {
    final failureOrSuccess = await placeOrder(NoParams());
    failureOrSuccess.fold(
          (failure) => emit(const CartError('Order failed.')),
          (_) {
        emit(CartOrderSuccess());
        emit(const CartLoaded(Cart(items: [])));
      },
    );
  }
}