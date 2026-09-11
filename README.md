# 📱 صانع حالات واتساب والستوري (Status & Quote Maker)

مشروع Flutter كامل وجاهز للتطوير، يحتوي على:

- **قوالب وخلفيات جاهزة**: متدرجة (Gradients) + إسلامية + كرتونية (`lib/models/background_model.dart`)
- **كتابة نص بخطوط عربية مزخرفة** (Cairo, Aref Ruqaa, Amiri, Lalezar, Rakkas, Marhey) عبر `google_fonts`
- **إطار Ring Light متحرك** حول التصميم بالكامل (`lib/widgets/ring_light_border.dart`) — تدرج لوني دائري يدور بلا توقف باستخدام `AnimationController` + `CustomPainter`
- **تصدير التصميم**: كصورة PNG فورية، أو كفيديو MP4 قصير (4 ثوانٍ) يظهر فيه دوران الإطار، جاهز للنشر المباشر على واتساب

---

## 🗂️ هيكل المشروع

```
whatsapp_status_maker/
├── pubspec.yaml                     # الاعتماديات (packages)
├── lib/
│   ├── main.dart                    # نقطة تشغيل التطبيق
│   ├── models/background_model.dart # قوالب/خلفيات جاهزة
│   ├── widgets/
│   │   ├── ring_light_border.dart   # الإطار المتحرك
│   │   └── text_style_picker.dart   # اختيار الخط العربي
│   ├── screens/
│   │   ├── home_screen.dart         # شاشة اختيار القالب
│   │   └── editor_screen.dart       # شاشة الكتابة والتصدير
│   └── services/export_service.dart # حفظ كصورة/فيديو + مشاركة
└── assets/
    ├── backgrounds/                 # ضع هنا صور الخلفيات (إسلامية/كرتونية)
    └── fonts/                       # (اختياري) خطوط محلية إن لم تستخدم Google Fonts أونلاين
```

---

## ⚙️ خطوة بخطوة: من الكود إلى تطبيق يعمل على جهازك

### 1) تجهيز بيئة Flutter (على جهاز الكمبيوتر، وليس داخل هذه المحادثة)
1. نزّل ونصّب **Flutter SDK** من الموقع الرسمي `flutter.dev`.
2. نصّب **Android Studio** (يشمل Android SDK + أدوات البناء).
3. تأكد من نجاح الفحص: 
   ```
   flutter doctor
   ```

### 2) إحضار المشروع وتشغيله
```bash
cd whatsapp_status_maker
flutter pub get
flutter run
```

### 3) إضافة الخلفيات (صور إسلامية/كرتونية)
- ضع صور PNG/JPG داخل `assets/backgrounds/` بنفس الأسماء المذكورة في `background_model.dart`
  (مثل `islamic_1.png`, `cartoon_1.png`)، أو غيّر الأسماء داخل الكود لتطابق ملفاتك.
- **مهم قانونيًا**: استخدم صورًا تملك حقوقها أو صورًا مرخّصة للاستخدام التجاري (مثل Freepik الترخيص المدفوع، أو تصميمك الخاص)، لتجنّب مشاكل الملكية الفكرية عند النشر والربح منها.

### 4) بناء ملف APK (نسخة قابلة للتثبيت المباشر)
```bash
flutter build apk --release
```
✅ الملف الناتج تجده في:
```
build/app/outputs/flutter-apk/app-release.apk
```
هذا هو ملف الـ APK الذي ترفعه مباشرة على **Aptoide** أو أي متجر بديل، أو توزّعه كرابط تحميل مباشر.

> لتقليل حجم الملف يمكنك أيضًا تجربة:
> ```bash
> flutter build apk --release --split-per-abi
> ```
> وهذا ينتج عدة ملفات APK أخف حسب نوع المعالج (arm64, armeabi... إلخ).

### 5) (اختياري) بناء App Bundle لمتجر جوجل بلاي لاحقًا
```bash
flutter build appbundle --release
```

---

## 🎬 ملاحظة مهمة حول تصدير الفيديو

خاصية "حفظ كفيديو قصير" في `export_service.dart` تعمل عبر:
1. التقاط عدة لقطات شاشة متتالية أثناء دوران إطار الـ Ring Light.
2. دمجها بواسطة **ffmpeg** (حزمة `ffmpeg_kit_flutter_new`) إلى ملف MP4.

هذه الطريقة تعمل لكنها **مكلفة على الأداء** نوعًا ما على الأجهزة الضعيفة (لأنها تلتقط صورة كل جزء من الثانية). قبل الإطلاق النهائي، يُنصح بـ:
- تجربة القيمة `fps` (عدد الإطارات في الثانية) بين 8-15 لإيجاد توازن بين جودة الحركة وسرعة الأداء.
- اختبار الحزمة `ffmpeg_kit_flutter_new` على جهاز Android حقيقي، فبعض إصدارات ffmpeg kit تحتاج ضبط صلاحيات التخزين في `AndroidManifest.xml`.

---

## 🔑 صلاحيات أندرويد المطلوبة

أضف هذه الصلاحيات داخل `android/app/src/main/AndroidManifest.xml` قبل وسم `<application>`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

(الصلاحية الأخيرة مطلوبة إذا كانت الخطوط تُحمَّل أونلاين عبر `google_fonts` — أو استخدم خطوطًا محلية كما هو موضح في `pubspec.yaml` لتجنب الحاجة للإنترنت).

---

## 🏪 النشر على Aptoide ومتاجر بديلة

خطوات عامة (تختلف تفاصيل الواجهة بمرور الوقت، يُفضّل مراجعة الموقع الرسمي عند التنفيذ):

1. أنشئ حساب "مطوّر" على منصة **Aptoide** (aptoide.com) عبر لوحة Aptoide Backstage.
2. ارفع ملف `app-release.apk` الناتج من الخطوة السابقة.
3. أضف: اسم التطبيق، الوصف بالعربي، أيقونة (512x512)، صور توضيحية (Screenshots) من التطبيق الفعلي.
4. حدد التصنيف (Photography / Entertainment) والفئة العمرية.
5. إذا أردت تفعيل الأرباح عبر الإعلانات، ادمج SDK إعلانات (مثل **AdMob**، أو شبكات بديلة تدعم متاجر خارج جوجل بلاي) قبل بناء الـ APK النهائي.

### ⚠️ تنبيهات مهمة قبل النشر لتحقيق أرباح فعلية وآمنة:
- **التوقيع الرقمي (Signing)**: لا تنشر أبدًا بتوقيع debug الافتراضي؛ أنشئ مفتاح توقيع خاص بك (`keytool`) واستخدمه في `key.properties` قبل `flutter build apk --release`، وإلا لن تقدر لاحقًا على تحديث نفس التطبيق بنفس المعرّف.
- **حقوق الخطوط والصور**: تأكد من ترخيص أي خط أو صورة كرتونية/إسلامية تستخدمها تجاريًا.
- **متاجر بديلة متعددة**: كل متجر (Aptoide, APKPure, Amazon Appstore...) له سياسات مختلفة بخصوص الإعلانات ونوع المحتوى، راجع سياسة كل متجر قبل الرفع لتفادي إزالة التطبيق لاحقًا.
- إذا كانت خطتك تشمل عمليات شراء داخل التطبيق، يلزمك دمج بوابة دفع مستقلة (مثل Stripe أو بوابة محلية) لأن Google Play Billing غير متاح خارج متجر جوجل.

---

## 🚀 أفكار للتوسع لاحقًا
- إضافة أدوات سحب وتكبير النص بحرية على الشاشة (Draggable/Resizable) بدل نص ثابت في المنتصف.
- إتاحة رفع صورة خلفية من معرض المستخدم بدل القوالب الجاهزة فقط.
- إضافة ملصقات (Stickers) وإيموجي قابلة للسحب.
- حفظ التصاميم "المفضلة" محليًا (باستخدام `shared_preferences` أو قاعدة بيانات محلية).
