import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'models.dart';

class OutfitScreen extends StatefulWidget {
  final Wardrobe wardrobe;
  const OutfitScreen({super.key, required this.wardrobe});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  final _random = Random();
  Map<ClothingType, ClothingItem> _outfit = {};

  void _generate() {
    final result = <ClothingType, ClothingItem>{};
    for (final type in ClothingType.values) {
      final options = widget.wardrobe.byType(type);
      if (options.isEmpty) continue;

      ClothingItem pick = options[_random.nextInt(options.length)];

      // قاعدة بسيطة: البنطلون ما يبقاش نفس لون التيشيرت
      if (type == ClothingType.pants &&
          result.containsKey(ClothingType.tshirt)) {
        final shirt = result[ClothingType.tshirt]!;
        if (pick.colorName == shirt.colorName) {
          final alternatives =
              options.where((e) => e.colorName != shirt.colorName).toList();
          if (alternatives.isNotEmpty) {
            pick = alternatives[_random.nextInt(alternatives.length)];
          }
        }
      }
      result[type] = pick;
    }
    setState(() => _outfit = result);
  }

  @override
  Widget build(BuildContext context) {
    final hasClothes = widget.wardrobe.items.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('طقم النهاردة')),
      drawer: const AppDrawer(),
      body: !hasClothes
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.style_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('ضيف هدومك الأول من تبويب "إضافة"'),
                ],
              ),
            )
          : _outfit.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.style),
                    label: const Text('طلعلي طقم'),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ..._outfit.entries.map((e) => _outfitCard(e.key, e.value)),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('بدّل الطقم'),
                    ),
                  ],
                ),
    );
  }

  Widget _outfitCard(ClothingType type, ClothingItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(item.imageBase64),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.displayType),
        subtitle: Text(item.colorName),
        trailing: IconButton(
          icon: const Icon(Icons.casino),
          tooltip: 'غيّر القطعة دي بس',
          onPressed: () {
            final options = widget.wardrobe
                .byType(type)
                .where((e) => e.id != item.id)
                .toList();
            if (options.isEmpty) return;
            setState(() {
              _outfit[type] = options[_random.nextInt(options.length)];
            });
          },
        ),
      ),
    );
  }
}
