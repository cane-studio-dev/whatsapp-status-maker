import 'package:flutter/material.dart';

/// أنواع الخلفيات المتاحة في التطبيق
enum BackgroundType { gradient, islamic, cartoon, image }

/// موديل يمثل خلفية أو قالب جاهز يمكن للمستخدم اختياره
class BackgroundModel {
  final String id;
  final String name;
  final BackgroundType type;

  /// تستخدم في حالة النوع gradient
  final List<Color>? gradientColors;

  /// تستخدم في حالة النوع islamic أو cartoon أو image (مسار صورة من assets)
  final String? assetPath;

  const BackgroundModel({
    required this.id,
    required this.name,
    required this.type,
    this.gradientColors,
    this.assetPath,
  });
}

/// مكتبة القوالب الجاهزة (يمكن التوسع فيها بسهولة بإضافة عناصر جديدة)
class BackgroundLibrary {
  static final List<BackgroundModel> all = [
    // ====== خلفيات متدرجة (Gradients) ======
    const BackgroundModel(
      id: 'grad_sunset',
      name: 'غروب دافئ',
      type: BackgroundType.gradient,
      gradientColors: [Color(0xFFFF512F), Color(0xFFDD2476)],
    ),
    const BackgroundModel(
      id: 'grad_ocean',
      name: 'محيط هادئ',
      type: BackgroundType.gradient,
      gradientColors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    ),
    const BackgroundModel(
      id: 'grad_royal',
      name: 'بنفسجي ملكي',
      type: BackgroundType.gradient,
      gradientColors: [Color(0xFF360033), Color(0xFF0B8793)],
    ),
    const BackgroundModel(
      id: 'grad_gold',
      name: 'ذهبي فاخر',
      type: BackgroundType.gradient,
      gradientColors: [Color(0xFFBF953F), Color(0xFFFCF6BA), Color(0xFFB38728)],
    ),

    // ====== خلفيات إسلامية (ضع صور زخارف/فوانيس/مساجد داخل assets/backgrounds) ======
    const BackgroundModel(
      id: 'islamic_pattern_1',
      name: 'زخرفة إسلامية خضراء',
      type: BackgroundType.islamic,
      assetPath: 'assets/backgrounds/islamic_1.png',
    ),
    const BackgroundModel(
      id: 'islamic_pattern_2',
      name: 'قبة وهلال',
      type: BackgroundType.islamic,
      assetPath: 'assets/backgrounds/islamic_2.png',
    ),

    // ====== خلفيات كرتونية ======
    const BackgroundModel(
      id: 'cartoon_1',
      name: 'كرتوني ملون',
      type: BackgroundType.cartoon,
      assetPath: 'assets/backgrounds/cartoon_1.png',
    ),
    const BackgroundModel(
      id: 'cartoon_2',
      name: 'سحابة وفقاعات',
      type: BackgroundType.cartoon,
      assetPath: 'assets/backgrounds/cartoon_2.png',
    ),
  ];
}
