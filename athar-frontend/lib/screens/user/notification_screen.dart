import 'package:flutter/material.dart';
import 'package:alkher/styles/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          'الإشعارات',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationCard(
            icon: Icons.favorite,
            color: Colors.red,
            title: 'تم قبول طلب التبرع',
            subtitle: 'شكراً لك على مساهمتك في مساعدة الآخرين.',
            time: 'منذ ساعتين',
          ),

          SizedBox(height: 12),

          NotificationCard(
            icon: Icons.shopping_bag,
            color: Colors.green,
            title: 'تم إضافة منتج جديد',
            subtitle: 'يمكنك الآن مشاهدة المنتجات الجديدة.',
            time: 'أمس',
          ),

          SizedBox(height: 12),

          NotificationCard(
            icon: Icons.campaign,
            color: Colors.orange,
            title: 'إعلان جديد',
            subtitle: 'تم نشر إعلان جديد قد يهمك.',
            time: 'منذ 3 أيام',
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
