import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../widgets/profile_components.dart';
import 'wishlist_screen.dart';
import 'order_history_screen.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const ProfileStatsCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MenuGroupTitle(title: 'Shopping'),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                    child: const ProfileMenuItem(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Color(0xFFFF6B35),
                      bgColor: Color(0xFFFFF0EB),
                      title: 'My Orders',
                      subtitle: 'Track, return or buy again',
                      badgeText: '2 active',
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },
                    child: ProfileMenuItem(
                      icon: Icons.favorite_border,
                      iconColor: const Color(0xFF9C27B0),
                      bgColor: const Color(0xFFF4EBFF),
                      title: 'Wishlist',
                      subtitle:
                          '${context.watch<WishlistProvider>().itemCount} saved items',
                    ),
                  ),

                  const SizedBox(height: 8),
                  const MenuGroupTitle(title: 'Account'),
                  const ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    iconColor: Color(0xFF2196F3),
                    bgColor: Color(0xFFEBF4FF),
                    title: 'Saved Addresses',
                    subtitle: 'Home, Work',
                  ),
                  const ProfileMenuItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: Color(0xFF4CAF50),
                    bgColor: Color(0xFFEDFFF4),
                    title: 'Payment Methods',
                    subtitle: 'Visa •••• 4242',
                  ),
                  const ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    iconColor: Color(0xFFFF6B35),
                    bgColor: Color(0xFFFFF0EB),
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().logout();

                      context.read<CartProvider>().clearCart();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) =>
                            false, // This false means "remove all previous screens"
                      );
                    },
                    child: const ProfileMenuItem(
                      icon: Icons.logout,
                      iconColor: Color(0xFFF44336),
                      bgColor: Color(0xFFFFEBEB),
                      title: 'Log Out',
                      subtitle: 'See you soon!',
                      titleColor: Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
