import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/admin/admin_dashboard_screen.dart';
import 'package:alkher/screens/seller/seller_screen.dart';
import 'package:alkher/screens/user/main_screen.dart';
import 'package:alkher/screens/register_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:alkher/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // Regex بسيط للتحقق من صيغة الإيميل
  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = authProvider.currentUser;

      if (user == null || user.token.isEmpty) {
        setState(() => _isLoading = false);
        if (!mounted) return;
        _showError('فشل تسجيل الدخول');
        return;
      }

      if (!mounted) return;
      await context.read<FavoriteProvider>().loadFavorites();

      setState(() => _isLoading = false);

      if (!mounted) return;

      Widget destination;
      if (user.role == 'seller') {
        destination = const SellerScreen();
      } else if (user.role == 'admin') {
        destination = const AdminDashboardScreen();
      } else {
        destination = const MainScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      _showError('حدث خطأ: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  void _handleForgotPassword() {
    // TODO: اربطها بشاشة استرجاع كلمة المرور الفعلية
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'استرجاع كلمة المرور',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إرسال رابط استرجاع كلمة المرور إلى بريدك الإلكتروني.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('حسناً'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Header ----------------
  // ارتفاع الهيدر يتحدد حسب المحتوى نفسه (padding) بدل ارتفاع مفروض بالقوة،
  // عشان ما يصير overflow جوه الهيدر لما نحاول نصغّره يدوياً وقت فتح الكيبورد.
  Widget _buildHeader({required bool isKeyboardOpen}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isKeyboardOpen ? 16 : 40,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: isKeyboardOpen ? 48 : 72,
            height: isKeyboardOpen ? 48 : 72,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(isKeyboardOpen ? 16 : 22),
              border: Border.all(
                color: AppColors.textOnPrimary.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.volunteer_activism,
              color: AppColors.textOnPrimary,
              size: isKeyboardOpen ? 24 : 34,
            ),
          ),
          SizedBox(height: isKeyboardOpen ? 10 : 16),
          Text(
            'مرحباً بك',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: isKeyboardOpen ? 20 : 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          // العنوان الفرعي يختفي لما الكيبورد يفتح عشان نوفر مساحة
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: isKeyboardOpen
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'سجّل دخولك للمتابعة',
                      style: TextStyle(
                        color: AppColors.textOnPrimary.withOpacity(0.75),
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- Form fields ----------------
  Widget _buildEmailField() {
    return CustomTextField(
      controller: emailController,
      hint: 'example@email.com',
      icon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!_emailRegex.hasMatch(v)) {
          return 'صيغة البريد الإلكتروني غير صحيحة';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: passwordController,
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _isLoading ? null : _handleLogin,
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.textOnPrimary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.textSecondary.withOpacity(0.25)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'أو',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.textSecondary.withOpacity(0.25)),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: تسجيل الدخول عبر جوجل
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.g_mobiledata, size: 26),
        label: const Text(
          'المتابعة عبر جوجل',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ليس لديك حساب؟',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text(
            'إنشاء حساب',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Form section ----------------
  Widget _buildFormSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'البريد الإلكتروني',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  const Text(
                    'كلمة المرور',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _handleForgotPassword,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 18),
                  _buildDivider(),
                  const SizedBox(height: 18),
                  _buildGoogleButton(),
                  const SizedBox(height: 20),
                  _buildSignupRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isKeyboardOpen = media.viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // الهيدر ياخذ ارتفاعه الطبيعي فقط (يصغّر تلقائياً وقت الكيبورد)
            _buildHeader(isKeyboardOpen: isKeyboardOpen),
            // Expanded هنا آمن لأنه جوه Column مباشرة تحت Scaffold/SafeArea
            // (قيود محددة وواضحة)، والفورم نفسه سكرول مستقل بداخله،
            // فما في أي احتمال overflow مهما كان حجم الكيبورد أو الشاشة.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      // نضمن إن البطاقة البيضاء تملأ المساحة المتاحة على الأقل
                      // (بدون ما تجبر المحتوى يتقصّر)، وتصير قابلة للسكرول
                      // تلقائياً إذا صار المحتوى أطول من المساحة (مثلاً وقت الكيبورد)
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: _buildFormSection(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}