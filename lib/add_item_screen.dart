import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_drawer.dart';
import 'models.dart';

class AddItemScreen extends StatefulWidget {
  final Wardrobe wardrobe;
  final VoidCallback onSaved;
  const AddItemScreen({super.key, required this.wardrobe, required this.onSaved});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _picker = ImagePicker();
  File? _image;
  ClothingType _type = ClothingType.tshirt;
  String _subType = AccessoryTypes.all.first;
  String _colorName = 'أسود';
  int _colorValue = 0xFF212121;
  bool _saving = false;

  static const _colors = [
    {'name': 'أسود', 'value': 0xFF212121},
    {'name': 'أبيض', 'value': 0xFFF5F5F5},
    {'name': 'رمادي', 'value': 0xFF9E9E9E},
    {'name': 'أحمر', 'value': 0xFFD32F2F},
    {'name': 'أزرق', 'value': 0xFF1976D2},
    {'name': 'كحلي', 'value': 0xFF1A237E},
    {'name': 'أخضر', 'value': 0xFF388E3C},
    {'name': 'بيج', 'value': 0xFFD7CCC8},
    {'name': 'أصفر', 'value': 0xFFFBC02D},
  ];

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 60);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    if (_image == null) return;
    setState(() => _saving = true);
    final bytes = await _image!.readAsBytes();
    final item = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _type,
      subType: _type == ClothingType.accessory ? _subType : '',
      colorName: _colorName,
      colorValue: _colorValue,
      imageBase64: base64Encode(bytes),
    );
    await widget.wardrobe.add(item);
    widget.onSaved();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة ${item.displayType} للدولاب')),
    );
    setState(() {
      _image = null;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة قطعة')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_image == null)
            Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('من المعرض'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('بالكاميرا'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!, height: 220, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          const Text('نوع القطعة',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<ClothingType>(
            value: _type,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ClothingType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          if (_type == ClothingType.accessory) ...[
            const SizedBox(height: 16),
            const Text('نوع الإكسسوار',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _subType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: AccessoryTypes.all
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _subType = v!),
            ),
          ],
          const SizedBox(height: 16),
          const Text('اللون', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _colors.map((c) {
              final selected = c['name'] == _colorName;
              return ChoiceChip(
                label: Text(c['name'] as String),
                selected: selected,
                avatar: CircleAvatar(
                  backgroundColor: Color(c['value'] as int),
                  radius: 10,
                ),
                onSelected: (_) => setState(() {
                  _colorName = c['name'] as String;
                  _colorValue = c['value'] as int;
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: (_image == null || _saving) ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(_saving ? 'بيحفظ...' : 'احفظ في الدولاب'),
          ),
        ],
      ),
    );
  }
}
