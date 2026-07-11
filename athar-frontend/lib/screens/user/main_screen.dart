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
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          // ── التعديل هنا: جعل الحواف بلون أخضر ناعم ومتناسق مع الهوية ──
          border: Border.all(
            color: AppColors.primary.withOpacity(
              0.15,
            ), // لون أخضر شفاف يعطي فخامة بدون حدة
            width: 1.5, // زيادة السمك قليلاً لتبرز الحافة
          ),
          boxShadow: [
            BoxShadow(
              // ظل ناعم مائل للأخضر الداكن ليعطي عمقاً جميلاً خلف الشريط
              color: AppColors.primaryDark.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            unselectedItemColor: AppColors.textSecondary,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 400),
            items: [
              SalomonBottomBarItem(
                icon: Icon(
                  _currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                ),
                title: const Text(
                  "الرئيسية",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
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
                  "المفضلة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
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
                  "الحساب",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
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
