import 'package:alkher/screens/seller/widgets/product_card.dart';
import 'package:alkher/screens/user/notification_screen.dart';
import 'package:alkher/screens/user/profile_screen_user.dart';
import 'package:alkher/screens/user/search_results_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderHomeScreen extends StatelessWidget {
  const HeaderHomeScreen({super.key, this.hasUnreadNotifications = false});

  /// يتحكم بظهور نقطة الإشعار غير المقروء فوق زر الجرس
  final bool hasUnreadNotifications;

  // اللون التركوازي مأخوذ من نقطة الشعار، يستخدم كلون مميز (accent)
  // بربط الهوية البصرية للشعار مع باقي عناصر الهيدر
  static const Color _brandAccent = Color(0xFF2FC6B6);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name;
    final displayName = (userName != null && userName.isNotEmpty)
        ? userName
        : 'زائر';
    final imageName = authProvider.profileImageName;
    final hasImage = imageName != null && imageName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreenUser(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: AppColors.surface,
                    backgroundImage: hasImage
                        ? NetworkImage(ProductCard.getImageUrl(imageName))
                        : null,
                    child: !hasImage
                        ?  Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 24,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'أهلاً بك، $displayName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'كل الخير في مكان واحد',
                      style: TextStyle(
                        color: AppColors.textOnPrimary.withOpacity(0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _BrandBar(
                hasUnread: hasUnreadNotifications,
                onNotificationTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchResultsScreen(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient:  LinearGradient(
                            colors: [
                              AppColors.primaryDark,
                              HeaderHomeScreen._brandAccent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                       Expanded(
                        child: Text(
                          'ابحث عن منتج، تبرع، وظيفة...',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                      Container(width: 1, height: 22, color: AppColors.border),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.tune_rounded,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar({required this.onNotificationTap, this.hasUnread = false});

  final VoidCallback onNotificationTap;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Image.asset(
              'lib/images/logo.png',
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: AppColors.border,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon:  Icon(
                  Icons.notifications_rounded,
                  color: AppColors.primaryDark,
                  size: 21,
                ),
              ),
              if (hasUnread)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HeaderHomeScreen._brandAccent,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}