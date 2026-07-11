import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:alkher/screens/seller/add_product_screen.dart';
import 'package:alkher/screens/seller/seller_profile_screen.dart';
import 'package:alkher/screens/seller/my_listing_screen.dart';
import 'package:alkher/styles/app_colors.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AddProductScreen(),
    MyListingsScreen(),
    SellerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primaryDark;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: activeColor.withOpacity(0.1),
              hoverColor: activeColor.withOpacity(0.05),
              gap: 8,
              activeColor: activeColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: activeColor.withOpacity(0.1),
              color: Colors.grey[600],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.add_box_outlined,
                  text: 'إضافة',
                ),
                GButton(
                  icon: Icons.list_alt_outlined,
                  text: 'إعلاناتي',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'الملف الشخصي',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}