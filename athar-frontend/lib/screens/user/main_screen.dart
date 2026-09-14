import 'package:alkher/screens/user/favorite_screen_user.dart';
import 'package:alkher/screens/user/home_screen.dart';
import 'package:alkher/screens/user/profile_screen_user.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final screens = [
    const HomeScreen(),
    const FavoriteScreenUser(),
    const ProfileScreenUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            unselectedItemColor: AppColors.textSecondary,
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 350),
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            items: [
              SalomonBottomBarItem(
                icon: Icon(
                  _currentIndex == 0
                      ? Icons.home_rounded
                      : Icons.home_outlined,
                ),
                title: const Text(
                  'الرئيسية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                selectedColor: AppColors.primary,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  _currentIndex == 1
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                title: const Text(
                  'المفضلة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                selectedColor: AppColors.secondary,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  _currentIndex == 2
                      ? Icons.person_rounded
                      : Icons.person_outline_rounded,
                ),
                title: const Text(
                  'الحساب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                selectedColor: AppColors.primaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}