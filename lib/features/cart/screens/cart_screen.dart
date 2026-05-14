import 'package:flutter/material.dart';
import '../../../core/mock_data.dart';
import '../../shop/models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [
      {
        'product': mockTrendingProducts[0],
        'variant': 'Orange · Size 10',
        'quantity': 1,
      },
      {
        'product': mockTrendingProducts[1],
        'variant': 'Midnight Black',
        'quantity': 1,
      },
      {
        'product': mockNewArrivals[2],
        'variant': 'Silver · 44mm',
        'quantity': 2,
      },
    ];
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double _calculateSubtotal() {
    double total = 0;
    for (var item in _cartItems) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      total += product.price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final discount = subtotal > 0 ? 94.80 : 0.0;
    final total = subtotal > 0 ? subtotal - discount : 0.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 214, 241),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 11, 11, 95),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Cart 🛒',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_cartItems.length} items selected',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                      ),
                    ],
                  ),
                  const Text(
                    'Edit',
                    style: TextStyle(color: Color(0xFFFF6B35), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cartItems.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        final product = item['product'] as Product;
                        final variant = item['variant'] as String;
                        final quantity = item['quantity'] as int;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEEEEF5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: product.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(product.emoji, style: const TextStyle(fontSize: 32)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      variant,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF9898B5)),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF7F6FF),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => _decrementQuantity(index),
                                                child: const Text('−', style: TextStyle(fontSize: 16, color: Color(0xFF4A4A6A), fontWeight: FontWeight.w300)),
                                              ),
                                              Container(
                                                constraints: const BoxConstraints(minWidth: 20),
                                                child: Text(
                                                  '$quantity',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => _incrementQuantity(index),
                                                child: const Text('+', style: TextStyle(fontSize: 16, color: Color(0xFF4A4A6A), fontWeight: FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => _removeItem(index),
                                child: const Icon(Icons.delete_outline, color: Color(0xFFFF4E7C), size: 20),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, color: Color(0xFFFF6B35), size: 18),
                          const SizedBox(width: 10),
                          const Text('Apply Promo Code', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                          const Spacer(),
                          const Text('SAVE10 →', style: TextStyle(fontSize: 11, color: Color(0xFF9898B5))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEEEEF5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal (${_cartItems.length} items)', style: const TextStyle(fontSize: 12, color: Color(0xFF9898B5))),
                              Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Discount (SAVE10)', style: TextStyle(fontSize: 12, color: Color(0xFF9898B5))),
                              Text('−\$${discount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery', style: TextStyle(fontSize: 12, color: Color(0xFF9898B5))),
                              const Text('Free 🎉', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: Color(0xFFEEEEF5), height: 1, thickness: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                            ],
                          ),
                          if (discount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('You save \$${discount.toStringAsFixed(2)} on this order!', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEF5))),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      'Proceed to Checkout — \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}