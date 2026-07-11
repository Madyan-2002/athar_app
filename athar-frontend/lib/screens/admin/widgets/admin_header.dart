import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final String title;

  const AdminHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}