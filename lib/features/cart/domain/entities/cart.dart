import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart_item.dart';

// Domain Entity for the Cart [cite: 26]
class Cart extends Equatable {
  final List<CartItem> items;

  const Cart({required this.items});

  // Helper to get total price
  double get totalPrice => items.fold(0, (total, item) => total + (item.product.price * item.quantity));

  // Helper to get total item count
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  @override
  List<Object?> get props => [items];
}