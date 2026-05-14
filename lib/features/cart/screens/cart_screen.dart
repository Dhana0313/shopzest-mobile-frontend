import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../widgets/cart_components.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 214, 241),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CartHeader(itemCount: cartProvider.itemCount),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty 🛒',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9898B5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return CartItemCard(
                                product: item.product,
                                variant: item.variant,
                                quantity: item.quantity,
                                onIncrement: () => context
                                    .read<CartProvider>()
                                    .incrementQuantity(index),
                                onDecrement: () => context
                                    .read<CartProvider>()
                                    .decrementQuantity(index),
                                onRemove: () => context
                                    .read<CartProvider>()
                                    .removeItem(index),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const PromoCodeBox(),
                          const SizedBox(height: 16),
                          OrderSummaryBox(
                            itemCount: cartProvider.itemCount,
                            subtotal: cartProvider.subtotal,
                            discount: cartProvider.discount,
                            total: cartProvider.total,
                          ),
                        ],
                      ),
                    ),
            ),
            if (items.isNotEmpty) CheckoutFooter(total: cartProvider.total),
          ],
        ),
      ),
    );
  }
}
