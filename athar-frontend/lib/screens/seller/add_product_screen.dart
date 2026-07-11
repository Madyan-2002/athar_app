import 'dart:io';
import 'package:alkher/models/category_model.dart';
import 'package:alkher/models/type_option.dart';
import 'package:alkher/screens/seller/widgets/action_buttons.dart';
import 'package:alkher/screens/seller/widgets/general_info_fields.dart';
import 'package:alkher/screens/seller/widgets/image_picker_field.dart';
import 'package:alkher/screens/seller/widgets/seller_header.dart';
import 'package:alkher/screens/seller/widgets/type_selector.dart';
import 'package:alkher/screens/seller/widgets/type_specific_fields.dart';
import 'package:alkher/services/category_service.dart';
import 'package:alkher/services/product_services.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  File? selectedImage;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _contactController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  DateTime? _deadline;
  bool _isLoading = false;
  String _selectedType = 'sell';

  final List<TypeOption> _types = const [
    TypeOption(
      'sell',
      'بيع',
      'اعرض منتج للبيع',
      Icons.sell_outlined,
      AppColors.primaryDark,
    ),
    TypeOption(
      'donation',
      'تبرع',
      'اطلب دعم لقضية',
      Icons.volunteer_activism_outlined,
      AppColors.primary,
    ),
    TypeOption(
      'job',
      'وظيفة',
      'أعلن عن فرصة عمل',
      Icons.work_outline,
      AppColors.secondary,
    ),
    TypeOption(
      'other',
      'أخرى',
      'أي إعلان آخر',
      Icons.category_outlined,
      Color(0xFF4E7C59),
    ),
  ];

  TypeOption get _currentType =>
      _types.firstWhere((t) => t.value == _selectedType);

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await CategoryService().getCategories();
      setState(() => _categories = cats);
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _contactController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _targetAmountController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await ImagePickerField.showSourcePicker(context);
    if (source == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descController.clear();
    _contactController.clear();
    _priceController.clear();
    _stockController.clear();
    _targetAmountController.clear();
    _salaryController.clear();
    _locationController.clear();
    setState(() {
      selectedImage = null;
      _selectedCategory = null;
      _deadline = null;
      _selectedType = 'sell';
    });
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (selectedImage == null) {
      _showSnack('الرجاء اختيار صورة للإعلان', isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await ProductServices().createProduct(
      title: _nameController.text.trim(),
      description: _descController.text.trim(),
      type: _selectedType,
      contactNumber: _contactController.text.trim(),
      image: selectedImage!,
      categoryId: _selectedType == 'sell' ? _selectedCategory?.id : null,
      price: _selectedType == 'sell'
          ? double.tryParse(_priceController.text)
          : null,
      stock: _selectedType == 'sell'
          ? int.tryParse(_stockController.text)
          : null,
      targetAmount: _selectedType == 'donation'
          ? double.tryParse(_targetAmountController.text)
          : null,
      deadline: _selectedType == 'donation' ? _deadline : null,
      salary: _selectedType == 'job'
          ? double.tryParse(_salaryController.text)
          : null,
      location: _selectedType == 'job' ? _locationController.text.trim() : null,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (success) {
      _showSnack('تم نشر الإعلان بنجاح', isError: false);
      _resetForm();
    } else {
      _showSnack('فشل نشر الإعلان، حاول مرة أخرى', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _currentType.color;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const SellerHeader(
              title: 'إضافة إعلان',
              subtitle: 'اختر نوع الإعلان واملأ التفاصيل',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TypeSelector(
                        types: _types,
                        selectedType: _selectedType,
                        onTypeChanged: (value) =>
                            setState(() => _selectedType = value),
                      ),
                      const SizedBox(height: 20),

                      ImagePickerField(
                        selectedImage: selectedImage,
                        accent: accent,
                        onPick: _pickImage,
                        onRemove: () => setState(() => selectedImage = null),
                      ),
                      const SizedBox(height: 16),

                      GeneralInfoFields(
                        accent: accent,
                        nameController: _nameController,
                        descController: _descController,
                        contactController: _contactController,
                      ),
                      const SizedBox(height: 12),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: TypeSpecificFields(
                          key: ValueKey(_selectedType),
                          selectedType: _selectedType,
                          accent: accent,
                          priceController: _priceController,
                          stockController: _stockController,
                          categories: _categories,
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          targetAmountController: _targetAmountController,
                          deadline: _deadline,
                          onPickDeadline: _pickDeadline,
                          salaryController: _salaryController,
                          locationController: _locationController,
                          onCategoryAdded: _loadCategories,
                        ),
                      ),
                      const SizedBox(height: 24),

                      ActionButtons(
                        accent: accent,
                        isLoading: _isLoading,
                        onCancel: _resetForm,
                        onSubmit: _submit,
                      ),
                    ],
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