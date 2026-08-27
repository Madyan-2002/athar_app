import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/services/auth_service.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:alkher/widget/custom_text_field.dart';
import 'package:alkher/widget/role_option.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String _selectedRole = 'customer';

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthService().register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: _selectedRole,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (user.name.isEmpty) {
        _showSnack('فشل إنشاء الحساب', isError: true);
        return;
      }

      _showSnack('تم إنشاء الحساب بنجاح، الرجاء تسجيل الدخول', isError: false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      _showSnack(
        'حدث خطأ: ${e.toString().replaceAll('Exception: ', '')}',
        isError: true,
      );
    }
  }

  // ---------------- Header ----------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.textOnPrimary.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_alt_1,
              color: AppColors.textOnPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'انضم إلينا وكن جزءًا من الخير',
            style: TextStyle(
              color: AppColors.textOnPrimary.withOpacity(0.75),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Form label + field helper ----------------
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: nameController,
      hint: 'اسمك الكامل',
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'الرجاء إدخال الاسم';
        }
        if (value.trim().length < 3) {
          return 'الاسم قصير جدًا';
        }
        return null;
      },
    );
  }

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

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      controller: confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء تأكيد كلمة المرور';
        }
        if (value != passwordController.text) {
          return 'كلمتا المرور غير متطابقتين';
        }
        return null;
      },
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        Expanded(
          child: RoleOption(
            label: 'مستخدم',
            subtitle: 'أشتري وأتصفح',
            icon: Icons.person_outline,
            isSelected: _selectedRole == 'customer',
            onTap: () => setState(() => _selectedRole = 'customer'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RoleOption(
            label: 'بائع / متبرع / صاحب عمل',
            subtitle: 'أنشر إعلانات',
            icon: Icons.storefront_outlined,
            isSelected: _selectedRole == 'seller',
            onTap: () => setState(() => _selectedRole = 'seller'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    final gradientColors = _isLoading
        ? [
            AppColors.primaryDark.withOpacity(0.5),
            AppColors.primary.withOpacity(0.5),
          ]
        : [
            AppColors.primaryDark,
            AppColors.primary,
          ];

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
          boxShadow: _isLoading
              ? []
              : [
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
            onTap: _isLoading ? null : _handleRegister,
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
                      'إنشاء الحساب',
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

  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'تسجيل الدخول',
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
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('الاسم الكامل'),
                  const SizedBox(height: 8),
                  _buildNameField(),
                  const SizedBox(height: 18),

                  _buildLabel('البريد الإلكتروني'),
                  const SizedBox(height: 8),
                  _buildEmailField(),
                  const SizedBox(height: 18),

                  _buildLabel('كلمة المرور'),
                  const SizedBox(height: 8),
                  _buildPasswordField(),
                  const SizedBox(height: 18),

                  _buildLabel('تأكيد كلمة المرور'),
                  const SizedBox(height: 8),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 22),

                  _buildLabel('نوع الحساب'),
                  const SizedBox(height: 10),
                  _buildRoleSelector(),
                  const SizedBox(height: 26),

                  _buildRegisterButton(),
                  const SizedBox(height: 20),
                  _buildLoginRow(),
                  const SizedBox(height: 12),
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
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // الهيدر ياخذ ارتفاعه الطبيعي من محتواه فقط
            _buildHeader(),
            // Expanded آمن هنا لأنه جوه Column مباشرة تحت Scaffold/SafeArea
            // (قيود محددة وواضحة)، والفورم سكرول مستقل بداخله،
            // فما في أي احتمال overflow وقت فتح الكيبورد
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
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