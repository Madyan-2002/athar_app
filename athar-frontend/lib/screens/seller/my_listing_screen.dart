import 'package:alkher/models/product_model.dart';
import 'package:alkher/services/product_services.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:alkher/screens/seller/widgets/product_card.dart';
import 'package:flutter/material.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<ProductModel> _listings = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'all';

  final List<_FilterOption> _filters = const [
    _FilterOption('all', 'الكل', Icons.grid_view_rounded),
    _FilterOption('sell', 'بيع', Icons.sell_outlined),
    _FilterOption('donation', 'تبرع', Icons.volunteer_activism_outlined),
    _FilterOption('job', 'وظيفة', Icons.work_outline),
    _FilterOption('other', 'أخرى', Icons.category_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ProductServices().getProducts(mine: true);
      setState(() {
        _listings = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل تحميل إعلاناتك';
        _isLoading = false;
      });
    }
  }

  List<ProductModel> get _filteredListings {
    if (_selectedFilter == 'all') return _listings;
    return _listings.where((p) => p.type == _selectedFilter).toList();
  }

  Future<bool> _confirmDelete(ProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف الإعلان'),
        content: Text(
          'هل أنت متأكد من حذف "${product.title}"؟\nلا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'حذف',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final success = await ProductServices().deleteProduct(product.id);

    if (!mounted) return;

    if (success) {
      setState(() => _listings.removeWhere((p) => p.id == product.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف "${product.title}"'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حذف الإعلان'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _loadListings(); // إعادة تحميل لو فشل الحذف (كان محذوف من الواجهة بس مش فعليًا)
    }
  }

  void _openEdit(ProductModel product) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditListingScreen(product: product),
      ),
    );
    if (updated == true) _loadListings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'إعلاناتي',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter.value;
            final count = filter.value == 'all'
                ? _listings.length
                : _listings.where((p) => p.type == filter.value).length;

            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surface
                      : Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter.icon,
                      size: 16,
                      color: isSelected ? AppColors.primaryDark : Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryDark
                            : Colors.white,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryDark.withOpacity(0.1)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.primaryDark
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
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
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadListings,
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

    final filtered = _filteredListings;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFilter == 'all'
                  ? 'لا توجد إعلانات بعد'
                  : 'لا توجد إعلانات بهذا النوع',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadListings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = filtered[index];
          return Dismissible(
            key: ValueKey(product.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _confirmDelete(product),
            onDismissed: (_) => _deleteProduct(product),
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 26,
              ),
            ),
            child: _ListingCard(
              product: product,
              onEdit: () => _openEdit(product),
              onDelete: () async {
                final confirmed = await _confirmDelete(product);
                if (confirmed) _deleteProduct(product);
              },
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

// ── بطاقة الإعلان بتصميم أوضح ──────────────────
class _ListingCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ListingCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  String _typeLabel() {
    switch (product.type) {
      case 'sell':
        return 'بيع';
      case 'donation':
        return 'تبرع';
      case 'job':
        return 'وظيفة';
      default:
        return 'أخرى';
    }
  }

  Color _typeColor() {
    switch (product.type) {
      case 'sell':
        return const Color(0xFF1976D2);
      case 'donation':
        return AppColors.primaryDark;
      case 'job':
        return const Color(0xFF6A1B9A);
      default:
        return Colors.grey.shade600;
    }
  }

  String? _valueText() {
    switch (product.type) {
      case 'sell':
        return product.price != null
            ? '\$${product.price!.toStringAsFixed(2)}'
            : null;
      case 'job':
        return product.salary != null
            ? '\$${product.salary!.toStringAsFixed(0)} / شهريًا'
            : null;
      case 'donation':
        return product.targetAmount != null
            ? 'الهدف: \$${product.targetAmount!.toStringAsFixed(0)}'
            : null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _valueText();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: product.images.isNotEmpty
                    ? Image.network(
                        ProductCard.getImageUrl(product.images.first),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textHint,
                            size: 22,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.textHint,
                          size: 22,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor().withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _typeColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (valueText != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      valueText,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _typeColor(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.error,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// شاشة التعديل — تدعم كل الأنواع، مش sell بس
// ═══════════════════════════════════════════════
class EditListingScreen extends StatefulWidget {
  final ProductModel product;
  const EditListingScreen({super.key, required this.product});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _salaryController;
  late final TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleController = TextEditingController(text: p.title);
    _descController = TextEditingController(text: p.description);
    _priceController = TextEditingController(text: p.price?.toString() ?? '');
    _stockController = TextEditingController(text: p.stock?.toString() ?? '');
    _targetAmountController = TextEditingController(
      text: p.targetAmount?.toString() ?? '',
    );
    _salaryController = TextEditingController(text: p.salary?.toString() ?? '');
    _locationController = TextEditingController(text: p.location ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _targetAmountController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    final type = widget.product.type;

    final success = await ProductServices().updateProduct(
      id: widget.product.id,
      title: _titleController.text,
      description: _descController.text,
      price: type == 'sell' ? double.tryParse(_priceController.text) : null,
      stock: type == 'sell' ? int.tryParse(_stockController.text) : null,
      targetAmount: type == 'donation'
          ? double.tryParse(_targetAmountController.text)
          : null,
      salary: type == 'job' ? double.tryParse(_salaryController.text) : null,
      location: type == 'job' ? _locationController.text : null,
      contactNumber: widget.product.contactNumber,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديلات'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حفظ التعديلات'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderFocus, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.product.type;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تعديل الإعلان'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: _decoration('العنوان'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: _decoration('الوصف'),
            ),

            if (type == 'sell') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _decoration('السعر'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration('الكمية'),
                    ),
                  ),
                ],
              ),
            ],

            if (type == 'donation') ...[
              const SizedBox(height: 14),
              TextField(
                controller: _targetAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _decoration('المبلغ المستهدف'),
              ),
            ],

            if (type == 'job') ...[
              const SizedBox(height: 14),
              TextField(
                controller: _salaryController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _decoration('الراتب'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _locationController,
                decoration: _decoration('الموقع'),
              ),
            ],

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.textOnPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'حفظ التعديلات',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
