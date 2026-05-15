import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../shop/widgets/home_components.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistItems = context.watch<WishlistProvider>().items;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('My Wishlist', style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💔', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(color: const Color(0xFF1A1A2E).withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: wishlistItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: wishlistItems[index]);
              },
            ),
    );
  }
}