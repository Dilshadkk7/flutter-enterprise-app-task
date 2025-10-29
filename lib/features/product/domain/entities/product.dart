import 'package:equatable/equatable.dart';

// Domain Entity for Product [cite: 26]
class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  @override
  List<Object?> get props => [id, title, price, description, category, image];
}