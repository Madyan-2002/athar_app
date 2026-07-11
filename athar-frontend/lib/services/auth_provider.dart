import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alkher/models/login_response.dart';
import 'package:alkher/services/auth_service.dart';
import 'package:alkher/services/token_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenServices _tokenServices = TokenServices();

  LoginResponse? _loginResponse;
  String? _profileImageName; // اسم الملف كما هو بالسيرفر (مش مسار محلي)

  LoginResponse? get currentUser => _loginResponse;
  bool get isAuthenticated => _loginResponse != null;
  String? get profileImageName => _profileImageName;

  // ── تسجيل الدخول ────────────────────────
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _loginResponse = await _authService.login(email: email, password: password);

    if (_loginResponse!.token.isNotEmpty) {
      await _tokenServices.saveToken(_loginResponse!.token);
      await _tokenServices.saveRole(_loginResponse!.role);
      await _tokenServices.saveUserInfo(
        name: _loginResponse!.name,
        email: _loginResponse!.email,
      );

      _profileImageName = _loginResponse!.image;
      if (_profileImageName != null && _profileImageName!.isNotEmpty) {
        await _tokenServices.saveProfileImage(_profileImageName!);
      } else {
        // مهم: امسح أي صورة قديمة محفوظة محليًا من حساب سابق
        await _tokenServices.saveProfileImage('');
      }
    }

    notifyListeners();
  }

  // ── تحديث الملف الشخصي (اسم/إيميل/صورة) ──────
  Future<void> updateProfile({
    required String name,
    required String email,
    String? password,
    File? imageFile,
  }) async {
    if (_loginResponse == null) return;

    final updated = await _authService.updateProfile(
      token: _loginResponse!.token,
      name: name,
      email: email,
      password: password,
      imageFile: imageFile,
    );

    // تحديث كامل ومتزامن: الذاكرة + التخزين الدائم مع بعض
    _loginResponse = updated;
    await _tokenServices.saveUserInfo(name: updated.name, email: updated.email);

    if (updated.image.isNotEmpty) {
      _profileImageName = updated.image;
      await _tokenServices.saveProfileImage(updated.image);
    }

    notifyListeners();
  }

  // ── استرجاع الجلسة بعد Restart ──────────────
  Future<void> loadUserFromStorage() async {
    final token = await _tokenServices.getToken();
    if (token == null || token.isEmpty) return;

    final name = await _tokenServices.getUserName();
    final email = await _tokenServices.getUserEmail();
    final role = await _tokenServices.getRole();
    final image = await _tokenServices.getProfileImage();

    if (name != null && email != null) {
      _loginResponse = LoginResponse(
        token: token,
        name: name,
        email: email,
        role: role ?? 'customer',
        image: image ?? '',
      );
      _profileImageName = image;
      notifyListeners();
    }
  }

  // ── تسجيل الخروج ────────────────────────
  Future<void> logoutUser() async {
    _loginResponse = null;
    _profileImageName = null;
    await _tokenServices.deleteToken();
    notifyListeners();
  }
}