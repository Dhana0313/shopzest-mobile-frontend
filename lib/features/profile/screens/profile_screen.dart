import 'package:flutter/material.dart';
import '../widgets/profile_components.dart';

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
                children: const [
                  MenuGroupTitle(title: 'Shopping'),
                  ProfileMenuItem(
                    icon: Icons.inventory_2_outlined,
                    iconColor: Color(0xFFFF6B35),
                    bgColor: Color(0xFFFFF0EB),
                    title: 'My Orders',
                    subtitle: 'Track, return or buy again',
                    badgeText: '2 active',
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    iconColor: Color(0xFF9C27B0),
                    bgColor: Color(0xFFF4EBFF),
                    title: 'Wishlist',
                    subtitle: '8 saved items',
                  ),
                  SizedBox(height: 8),
                  MenuGroupTitle(title: 'Account'),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    iconColor: Color(0xFF2196F3),
                    bgColor: Color(0xFFEBF4FF),
                    title: 'Saved Addresses',
                    subtitle: 'Home, Work',
                  ),
                  ProfileMenuItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: Color(0xFF4CAF50),
                    bgColor: Color(0xFFEDFFF4),
                    title: 'Payment Methods',
                    subtitle: 'Visa •••• 4242',
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    iconColor: Color(0xFFFF6B35),
                    bgColor: Color(0xFFFFF0EB),
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    iconColor: Color(0xFFF44336),
                    bgColor: Color(0xFFFFEBEB),
                    title: 'Log Out',
                    subtitle: 'See you soon!',
                    titleColor: Color(0xFFF44336),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}