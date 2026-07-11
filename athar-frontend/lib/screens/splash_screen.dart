import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/admin/admin_dashboard_screen.dart';
import 'package:alkher/screens/intro_pages.dart';
import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/screens/seller/seller_screen.dart';
import 'package:alkher/screens/user/main_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/services/token_services.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final AnimationController _textController;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;

  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _textOpacity = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _textController.forward();
    });

    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (isFirstTime) {
      if (!mounted) return;
      _navigateTo(const IntroPages());
      return;
    }

    final token = await TokenServices().getToken();
    final role = await TokenServices().getRole();

    Widget destination;

    if (token == null || token.isEmpty) {
      destination = const LoginScreen();
    } else {
      if (!mounted) return;

      await context.read<AuthProvider>().loadUserFromStorage();
      await context.read<FavoriteProvider>().loadFavorites();

      if (role == 'seller') {
        destination = const SellerScreen();
      } else if (role == 'admin') {
        destination = const AdminDashboardScreen();
      } else if (role == 'customer') {
        destination = const MainScreen();
      } else {
        destination = const LoginScreen();
      }
    }

    if (!mounted) return;
    _navigateTo(destination);
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: Stack(
          children: [
            // ── زخرفة دوائر شفافة بالخلفية ──────────
            Positioned(
              top: -70,
              left: -50,
              child: _decorativeCircle(220),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: _decorativeCircle(260),
            ),
            Positioned(
              top: 120,
              right: -30,
              child: _decorativeCircle(90),
            ),

            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── الشعار مع توهج طبقي ──────────
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15),
                                blurRadius: 0,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.volunteer_activism,
                            size: 62,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── النص بحركة انزلاق من الأسفل ──────────
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            const Text(
                              'أثر',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textOnPrimary,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 36,
                              height: 2.5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'معًا نصنع الخير',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textOnPrimary.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── مؤشر تحميل نقطي بالأسفل ──────────
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _dotsController,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final delay = i * 0.2;
                        final value = (_dotsController.value - delay) % 1.0;
                        final scale = value < 0.5
                            ? 0.6 + (value * 2 * 0.6)
                            : 1.2 - ((value - 0.5) * 2 * 0.6);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textOnPrimary.withOpacity(
                              0.4 + (scale - 0.6) * 0.75,
                            ),
                          ),
                          transform: Matrix4.identity()..scale(scale.clamp(0.6, 1.2)),
                          transformAlignment: Alignment.center,
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.06),
      ),
    );
  }
}