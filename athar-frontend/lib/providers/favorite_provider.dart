import 'package:flutter/material.dart';
import 'package:alkher/services/favorite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();

  final Set<String> _favoriteIds = {};
  bool _isLoaded = false;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  Future<void> loadFavorites() async {
    if (_isLoaded) return;

    try {
      final ids = await _service.getFavoriteIds();
      _favoriteIds
        ..clear()
        ..addAll(ids);
      _isLoaded = true;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggle(String productId) async {
    final wasAlreadyFavorite = _favoriteIds.contains(productId);

    if (wasAlreadyFavorite) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();

    try {
      final isFavoriteNow = await _service.toggle(productId);

      if (isFavoriteNow && !_favoriteIds.contains(productId)) {
        _favoriteIds.add(productId);
        notifyListeners();
      } else if (!isFavoriteNow && _favoriteIds.contains(productId)) {
        _favoriteIds.remove(productId);
        notifyListeners();
      }
    } catch (_) {
      if (wasAlreadyFavorite) {
        _favoriteIds.add(productId);
      } else {
        _favoriteIds.remove(productId);
      }
      notifyListeners();
    }
  }

  // الدالة القديمة المعدلة لتصبح Future وتدعم المسح الشامل
  Future<void> clearAll() async {
    // 1. نسخ العناصر الحالية للاحتياط في حال فشل السيرفر
    final previousFavorites = Set<String>.from(_favoriteIds);

    // 2. مسح العناصر محلياً فوراً لتحديث الواجهة بسرعة (Optimistic Update)
    _favoriteIds.clear();
    notifyListeners();

    try {
      // 3. استدعاء دالة حذف الكل من السيرفر (تأكد من وجودها أو دعمها في الـ Service الخاص بك)
      // إذا لم تكن موجودة بالسيرفر بعد، يمكنك الاكتفاء بالمسح المحلي مؤقتاً
      await _service.clearAllFavorites(); 
    } catch (_) {
      // في حال حدوث خطأ في السيرفر، نعيد العناصر كما كانت
      _favoriteIds.addAll(previousFavorites);
      notifyListeners();
      rethrow; // نمرر الخطأ للشاشة لإظهار تنبيه للمستخدم
    }
  }

  void clear() {
    _favoriteIds.clear();
    _isLoaded = false;
    notifyListeners();
  }
}