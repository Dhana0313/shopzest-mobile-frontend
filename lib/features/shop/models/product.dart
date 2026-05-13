import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? oldPrice;
  final double rating;
  final String reviews;
  final String emoji;
  final Color bgColor;
  final String? discountBadge;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.emoji,
    required this.bgColor,
    this.discountBadge,
  });
}