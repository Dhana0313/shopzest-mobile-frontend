import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../widgets/checkout_components.dart';
import 'payment_screen.dart';
import 'map_selection_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedAddress = '123 Tech Park Avenue,\nSuite 400, NY 10001';

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CheckoutSectionHeader(title: 'Shipping Address'),
                  CheckoutSelectionCard(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFFF6B35),
                    bgColor: const Color(0xFFFFF0EB),
                    title: 'Home Address',
                    subtitle: _selectedAddress,
                    onTap: () async {
                      final newAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapSelectionScreen(),
                        ),
                      );

                      if (newAddress != null && newAddress is String) {
                        setState(() {
                          _selectedAddress = newAddress;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  const CheckoutSectionHeader(title: 'Payment Method'),
                  const CheckoutSelectionCard(
                    icon: Icons.credit_card,
                    iconColor: Color(0xFF2196F3),
                    bgColor: Color(0xFFEBF4FF),
                    title: 'Credit or Debit Card',
                    subtitle: 'Add details on next step',
                  ),
                  const SizedBox(height: 24),

                  const CheckoutSectionHeader(title: 'Order Summary'),
                  OrderSummaryCard(
                    itemCount: cartProvider.itemCount,
                    subtotal: cartProvider.subtotal,
                    discount: cartProvider.discount,
                    total: cartProvider.total,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEF5))),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
