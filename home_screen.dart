import 'package:flutter/material.dart';
import '../models/background_model.dart';
import 'editor_screen.dart';

/// الشاشة الرئيسية: عرض القوالب والخلفيات الجاهزة مصنّفة
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BackgroundType _selectedTab = BackgroundType.gradient;

  final Map<BackgroundType, String> _tabLabels = const {
    BackgroundType.gradient: 'متدرجة',
    BackgroundType.islamic: 'إسلامية',
    BackgroundType.cartoon: 'كرتونية',
  };

  @override
  Widget build(BuildContext context) {
    final items = BackgroundLibrary.all
        .where((b) => b.type == _selectedTab)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('صانع الحالات والستوري ✨'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // شريط التصنيفات
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _tabLabels.entries.map((entry) {
                final selected = entry.key == _selectedTab;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedTab = entry.key),
                    selectedColor: const Color(0xFF25D366),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 9 / 16, // نسبة الستوري
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final bg = items[index];
                return _TemplateCard(background: bg);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // فتح المحرر بخلفية فارغة (تدرج افتراضي) ليبدأ المستخدم من الصفر
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditorScreen(background: BackgroundLibrary.all.first),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('تصميم جديد'),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final BackgroundModel background;
  const _TemplateCard({required this.background});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditorScreen(background: background)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (background.type == BackgroundType.gradient)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: background.gradientColors!,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              )
            else
              Image.asset(
                background.assetPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
              ),
            Positioned(
              bottom: 8,
              right: 8,
              left: 8,
              child: Text(
                background.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
