import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../models/background_model.dart';
import '../widgets/ring_light_border.dart';
import '../widgets/text_style_picker.dart';
import '../services/export_service.dart';

/// شاشة تحرير التصميم: خلفية + نص عربي + إطار Ring Light + أزرار حفظ/مشاركة
class EditorScreen extends StatefulWidget {
  final BackgroundModel background;
  const EditorScreen({super.key, required this.background});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _textController = TextEditingController(text: 'اكتب اقتباسك هنا ✍️');

  String _selectedFont = ArabicFonts.styles.keys.first;
  Color _textColor = Colors.white;
  double _fontSize = 28;
  bool _ringLightEnabled = true;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محرر التصميم'),
        actions: [
          IconButton(
            tooltip: 'تفعيل/إيقاف إطار Ring Light',
            icon: Icon(_ringLightEnabled ? Icons.blur_circular : Icons.blur_off),
            onPressed: () => setState(() => _ringLightEnabled = !_ringLightEnabled),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== منطقة المعاينة والتصدير =====
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Screenshot(
                    controller: _screenshotController,
                    child: _ringLightEnabled
                        ? RingLightBorder(child: _buildCanvas())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildCanvas(),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // ===== أدوات التحكم =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF111B21),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'اكتب النص هنا...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextStylePicker(
                  selectedFont: _selectedFont,
                  onFontSelected: (font) => setState(() => _selectedFont = font),
                ),
                Row(
                  children: [
                    const Text('حجم الخط'),
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 14,
                        max: 60,
                        onChanged: (v) => setState(() => _fontSize = v),
                      ),
                    ),
                    _colorDot(Colors.white),
                    _colorDot(Colors.amberAccent),
                    _colorDot(Colors.pinkAccent),
                    _colorDot(Colors.lightBlueAccent),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isExporting ? null : () => _export(asVideo: false),
                        icon: const Icon(Icons.image),
                        label: const Text('حفظ كصورة'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isExporting ? null : () => _export(asVideo: true),
                        icon: const Icon(Icons.videocam),
                        label: const Text('حفظ كفيديو قصير'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
                if (_isExporting) ...[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _textColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _textColor == color ? const Color(0xFF25D366) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }

  /// بناء لوحة التصميم نفسها (الخلفية + النص) بدون الإطار المتحرك
  Widget _buildCanvas() {
    final bg = widget.background;

    return Container(
      decoration: BoxDecoration(
        gradient: bg.type == BackgroundType.gradient
            ? LinearGradient(
                colors: bg.gradientColors!,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            : null,
        image: bg.type != BackgroundType.gradient
            ? DecorationImage(image: AssetImage(bg.assetPath!), fit: BoxFit.cover)
            : null,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(
        _textController.text,
        textAlign: TextAlign.center,
        style: ArabicFonts.styles[_selectedFont]!(
          fontSize: _fontSize,
          color: _textColor,
        ),
      ),
    );
  }

  Future<void> _export({required bool asVideo}) async {
    setState(() => _isExporting = true);
    try {
      if (asVideo) {
        await ExportService.exportShortVideo(
          screenshotController: _screenshotController,
          durationSeconds: 4,
        );
      } else {
        await ExportService.exportImage(_screenshotController);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(asVideo ? 'تم حفظ الفيديو بنجاح ✅' : 'تم حفظ الصورة بنجاح ✅')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التصدير: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}
