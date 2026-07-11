import 'package:alkher/models/product_model.dart';
import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _query = widget.initialQuery.trim().toLowerCase();

    // تأكد إن البيانات محمّلة (لو المستخدم دخل الشاشة قبل ما تحمّل الرئيسية)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      if (!provider.isAllLoaded) {
        provider.fetchAllTypes();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductModel> _filter(List<ProductModel> all) {
    if (_query.isEmpty) return [];
    return all.where((p) {
      final title = p.title.toLowerCase();
      final desc = p.description.toLowerCase();
      return title.contains(_query) || desc.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(12, 20, 20, 15),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _controller,
                autofocus: widget.initialQuery.isEmpty,
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج، تبرع، وظيفة...',
                  hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18, color: AppColors.textHint),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (!provider.isAllLoaded) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (_query.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_rounded, size: 56, color: AppColors.textHint),
                SizedBox(height: 12),
                Text('ابدأ الكتابة للبحث', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        final results = _filter(provider.allProductsCombined);

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text('لا توجد نتائج لـ "$_query"',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                '${results.length} نتيجة',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) => CustomCard(product: results[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}