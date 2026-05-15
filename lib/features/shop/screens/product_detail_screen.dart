import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/custom_notification.dart';
import '../widgets/product_detail_components.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedColorIndex = 0;

  final List<Color> _availableColors = [
    const Color(0xFFFF6B35),
    const Color(0xFF1A1A2E),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
  ];

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _handleAddToCart() {
    List<String> colorNames = ['Orange', 'Midnight', 'Green', 'Blue'];
    String selectedVariant = colorNames[_selectedColorIndex];

    context.read<CartProvider>().addItem(
      widget.product,
      selectedVariant,
      _quantity,
    );

    CustomNotification.show(
      context,
      title: 'Added to Cart',
      message: '${_quantity}x ${widget.product.name} is waiting for you.',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const DetailAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailHeroImage(product: widget.product),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailInfoSection(product: widget.product),
                          const SizedBox(height: 24),
                          DetailColorSelector(
                            availableColors: _availableColors,
                            selectedIndex: _selectedColorIndex,
                            onColorSelected: (index) {
                              setState(() {
                                _selectedColorIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          DetailQuantityRow(
                            quantity: _quantity,
                            onIncrement: _incrementQuantity,
                            onDecrement: _decrementQuantity,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'This premium product features signature technology for superior comfort and performance. Designed with high-quality materials to ensure durability while providing an excellent user experience. Ideal for daily use.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A4A6A),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const DetailBenefits(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DetailBottomBar(
              product: widget.product,
              totalPrice: widget.product.price * _quantity,
              onAddToCart: _handleAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}