import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/styles/app_colors.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({super.key});

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "رؤيتنا",
      "subtitle": "الريادة والأثر المستدام",
      "description":
          "أن يكون تطبيق أثر نموذجاً رائداً في تأهيل وتطوير الشباب والمجتمع لبناء جيل ممكن يساهم في تنمية وطنه",
      "icon": Icons.remove_red_eye_rounded,
      "bgGradient": [AppColors.primaryDark, AppColors.primary],
    },
    {
      "title": "رسالتنا",
      "subtitle": "تمكين وتطوير مستمر",
      "description":
          "نعمل على تطوير وتمكين الشباب والمجتمع تأهيلاً شاملاً، من خلال بيئة محفزة وبرامج نوعية وشراكات فاعلة تسهم في التنمية المستدامة",
      "icon": Icons.rocket_launch_rounded,
      "bgGradient": [Color(0xFF0D3B2E), AppColors.primary],
    },
    {
      "title": "قيمنا",
      "subtitle": "المبادئ التي تحركنا",
      "description":
          "الإبداع والابتكار • التطوع والعطاء • المسؤولية المجتمعية • الشراكة والتكامل • الشفافية والتميز",
      "icon": Icons.gavel_rounded,
      "bgGradient": [AppColors.primaryDark, Color(0xFF4E7C59)],
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentGradient =
        _onboardingData[_currentPage]["bgGradient"] as List<Color>;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ── زخرفة دوائر خلفية شفافة ──────────
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              left: -70,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            SafeArea(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return _buildPageContent(item);
                },
              ),
            ),

            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity:
                        _currentPage == _onboardingData.length - 1 ? 0.0 : 1.0,
                    child: TextButton(
                      onPressed: _currentPage == _onboardingData.length - 1
                          ? null
                          : () => _completeOnboarding(),
                      child: const Text(
                        "تخطّي",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildIndicator(index),
                    ),
                  ),

                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    icon: Icon(
                      _currentPage == _onboardingData.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      color: currentGradient.first,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── أيقونة بخلفية زجاجية شفافة ──────────
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(38),
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(
              item["icon"],
              size: 66,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 44),

          Text(
            item["title"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            item["subtitle"],
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 26),

          // ── بطاقة الوصف الزجاجية (Glassmorphism) ──────────
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Text(
              item["description"],
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 14.5,
                height: 1.8,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}