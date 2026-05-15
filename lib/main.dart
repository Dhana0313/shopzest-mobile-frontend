import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/layout/main_layout.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/wishlist_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopZest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DMSans',
        scaffoldBackgroundColor: const Color(0xFFF7F6FF),
      ),
      home: const MainLayout(),
    );
  }
}