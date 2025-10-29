import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';

// Domain Entity for a Cart Item [cite: 26]
class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}