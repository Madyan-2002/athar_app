import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/screens/splash_screen.dart';
import 'package:alkher/styles/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => FavoriteProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(
            title: 'Alkher',
            debugShowCheckedModeBanner: false,

            // إعدادات اللغة العربية والاتجاهات
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'), // دعم اللغة العربية
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // تجميع الـ TextScaler مع Directionality داخل الـ builder
            builder: (context, widget) {
              final mediaQuery = MediaQuery.of(context);
              final screenWidth = mediaQuery.size.width;

              double scaleFactor = screenWidth / 375;
              scaleFactor = scaleFactor.clamp(0.85, 1.25);

              return Directionality(
                textDirection: TextDirection.rtl,
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                  child: widget!,
                ),
              );
            },

            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                surface: AppColors.surface,
              ),
              scaffoldBackgroundColor: AppColors.background,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.borderFocus,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}