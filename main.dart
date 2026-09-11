import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StatusQuoteApp());
}

/// التطبيق الرئيسي: صانع حالات واتساب وستوري
class StatusQuoteApp extends StatelessWidget {
  const StatusQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صانع الحالات والستوري',
      debugShowCheckedModeBanner: false,
      // دعم الاتجاه من اليمين لليسار للغة العربية
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF25D366), // أخضر واتساب
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B141A),
        fontFamily: 'Cairo',
      ),
      builder: (context, child) {
        // إجبار اتجاه الواجهة على RTL
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
