import 'package:alkher/models/admin_user_model.dart';
import 'package:alkher/screens/admin/widgets/admin_header.dart';
import 'package:alkher/services/admin_user_service.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<AdminUserModel> _users = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'all';

  final List<_FilterOption> _filters = const [
    _FilterOption('all', 'الكل', Icons.people_outline),
    _FilterOption('customer', 'مستخدم', Icons.person_outline),
    _FilterOption('seller', 'بائع', Icons.storefront_outlined),
    _FilterOption('admin', 'أدمن', Icons.admin_panel_settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await AdminUserService().getAllUsers();
      setState(() {
        _users = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل تحميل المستخدمين';
        _isLoading = false;
      });
    }
  }

  List<AdminUserModel> get _filteredUsers {
    if (_selectedFilter == 'all') return _users;
    return _users.where((u) => u.role == _selectedFilter).toList();
  }

  Future<void> _confirmDelete(AdminUserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف الحساب'),
        content: Text(
          'هل أنت متأكد من حذف حساب "${user.name}"؟\nسيتم حذف جميع بياناته نهائيًا.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await AdminUserService().deleteUser(user.id);

    if (!mounted) return;

    if (success) {
      setState(() => _users.removeWhere((u) => u.id == user.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف حساب "${user.name}"'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حذف الحساب'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'seller':
        return const Color(0xFF1976D2);
      case 'admin':
        return const Color(0xFF6A1B9A);
      default:
        return AppColors.primaryDark;
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'seller':
        return 'بائع';
      case 'admin':
        return 'أدمن';
      default:
        return 'مستخدم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.primaryDark,
              child: Column(
                children: [
                  const AdminHeader(title: 'إدارة المستخدمين'),
                  _buildFilterBar(),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter.value;
            final count = filter.value == 'all'
                ? _users.length
                : _users.where((u) => u.role == filter.value).length;

            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(filter.icon,
                        size: 15, color: isSelected ? AppColors.primaryDark : Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      filter.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($count)',
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? AppColors.primaryDark.withOpacity(0.6)
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadUsers,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final filtered = _filteredUsers;

    if (filtered.isEmpty) {
      return const Center(
        child: Text('لا يوجد مستخدمون', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadUsers,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final user = filtered[index];
          final color = _roleColor(user.role);

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(Icons.person_outline, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _roleLabel(user.role),
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                    ],
                  ),
                ),
                if (user.role != 'admin')
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () => _confirmDelete(user),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterOption {
  final String value;
  final String label;
  final IconData icon;
  const _FilterOption(this.value, this.label, this.icon);
}