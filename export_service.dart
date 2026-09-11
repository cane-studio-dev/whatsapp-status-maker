import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
// ملاحظة: تحويل الصور إلى فيديو يعتمد على ffmpeg_kit_flutter_new
// وقد يحتاج ضبط صلاحيات/إعدادات إضافية على أندرويد (راجع ملف README).
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

/// خدمة مسؤولة عن التقاط التصميم وحفظه/مشاركته كصورة أو كفيديو قصير
class ExportService {
  /// حفظ التصميم الحالي كصورة PNG عالية الجودة في معرض الصور
  static Future<void> exportImage(ScreenshotController controller) async {
    final bytes = await controller.capture(pixelRatio: 3.0);
    if (bytes == null) throw Exception('فشل التقاط الصورة');

    // حفظ في المعرض مباشرة
    await ImageGallerySaver.saveImage(bytes, quality: 100, name: 'status_${DateTime.now().millisecondsSinceEpoch}');

    // (اختياري) فتح نافذة مشاركة فورية على واتساب أو أي تطبيق آخر
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/status_share.png');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'صنعته بتطبيق صانع الحالات ✨');
  }

  /// حفظ التصميم كفيديو قصير (عن طريق التقاط عدة إطارات أثناء دوران الـ Ring Light
  /// ثم دمجها بواسطة ffmpeg إلى فيديو mp4 قصير جاهز للنشر كستوري)
  static Future<void> exportShortVideo({
    required ScreenshotController screenshotController,
    int durationSeconds = 4,
    int fps = 12,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final framesDir = Directory('${tempDir.path}/status_frames');
    if (framesDir.existsSync()) framesDir.deleteSync(recursive: true);
    framesDir.createSync();

    final totalFrames = durationSeconds * fps;

    // التقاط سلسلة من اللقطات بفاصل زمني قصير حتى تظهر حركة دوران الإطار
    for (int i = 0; i < totalFrames; i++) {
      final bytes = await screenshotController.capture(pixelRatio: 2.0);
      if (bytes != null) {
        final framePath =
            '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png';
        await File(framePath).writeAsBytes(bytes);
      }
      await Future.delayed(Duration(milliseconds: (1000 / fps).round()));
    }

    // دمج الإطارات في فيديو mp4 باستخدام ffmpeg
    final outputPath = '${tempDir.path}/status_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final command =
        '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png -c:v mpeg4 -q:v 3 -pix_fmt yuv420p $outputPath';

    await FFmpegKit.execute(command);

    // حفظ الفيديو الناتج في المعرض
    await ImageGallerySaver.saveFile(outputPath);

    // مشاركة فورية
    await Share.shareXFiles([XFile(outputPath)], text: 'ستوري متحرك صنعته بالتطبيق ✨');
  }
}
