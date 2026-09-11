import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// قائمة الخطوط العربية المزخرفة المتاحة للمستخدم
/// (تأكد من أن الخط مدعوم في حزمة google_fonts، أو أضفه يدويًا في pubspec كخط محلي)
class ArabicFonts {
  static final Map<String, TextStyle Function({double? fontSize, Color? color})> styles = {
    'القاهرة (عصري)': ({fontSize, color}) =>
        GoogleFonts.cairo(fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
    'عارف رقعة (خط ديواني)': ({fontSize, color}) =>
        GoogleFonts.arefRuqaa(fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
    'أميري (نسخي كلاسيكي)': ({fontSize, color}) =>
        GoogleFonts.amiri(fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
    'لاليزار (كرتوني عريض)': ({fontSize, color}) =>
        GoogleFonts.lalezar(fontSize: fontSize, color: color),
    'رقعة (Rakkas)': ({fontSize, color}) =>
        GoogleFonts.rakkas(fontSize: fontSize, color: color),
    'مرحبا (Marhey)': ({fontSize, color}) =>
        GoogleFonts.marhey(fontSize: fontSize, color: color, fontWeight: FontWeight.w600),
  };
}

/// شريط أفقي لاختيار الخط
class TextStylePicker extends StatelessWidget {
  final String selectedFont;
  final ValueChanged<String> onFontSelected;

  const TextStylePicker({
    super.key,
    required this.selectedFont,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fontNames = ArabicFonts.styles.keys.toList();

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fontNames.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final name = fontNames[index];
          final isSelected = name == selectedFont;
          return ChoiceChip(
            label: Text(
              'أب',
              style: ArabicFonts.styles[name]!(fontSize: 18, color: Colors.white),
            ),
            selected: isSelected,
            onSelected: (_) => onFontSelected(name),
            selectedColor: const Color(0xFF25D366),
            tooltip: name,
          );
        },
      ),
    );
  }
}
