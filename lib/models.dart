import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum ClothingType { tshirt, pants, jacket, shoes, accessory }

extension ClothingTypeX on ClothingType {
  String get label {
    switch (this) {
      case ClothingType.tshirt:
        return 'تيشيرت';
      case ClothingType.pants:
        return 'بنطلون';
      case ClothingType.jacket:
        return 'جاكيت';
      case ClothingType.shoes:
        return 'جزمة';
      case ClothingType.accessory:
        return 'إكسسوار';
    }
  }
}

/// أنواع الإكسسوار الفرعية
class AccessoryTypes {
  static const List<String> all = [
    'سلسلة',
    'ساعة',
    'خاتم',
    'حلق',
    'سوار',
    'كوشة',
  ];
}

class ClothingItem {
  final String id;
  final ClothingType type;
  final String subType;
  final String colorName;
  final int colorValue;
  final String imageBase64;

  const ClothingItem({
    required this.id,
    required this.type,
    this.subType = '',
    required this.colorName,
    required this.colorValue,
    required this.imageBase64,
  });

  String get displayType {
    if (type == ClothingType.accessory && subType.isNotEmpty) {
      return 'إكسسوار • $subType';
    }
    return type.label;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'subType': subType,
        'colorName': colorName,
        'colorValue': colorValue,
        'imageBase64': imageBase64,
      };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
        id: json['id'] as String,
        type: ClothingType.values.byName(json['type'] as String),
        subType: (json['subType'] ?? '') as String,
        colorName: json['colorName'] as String,
        colorValue: json['colorValue'] as int,
        imageBase64: json['imageBase64'] as String,
      );
}

class Wardrobe {
  List<ClothingItem> items = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wardrobe_items') ?? '[]';
    final decoded = jsonDecode(raw) as List<dynamic>;
    items = decoded
        .map((e) => ClothingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> add(ClothingItem item) async {
    items.add(item);
    await _persist();
  }

  Future<void> remove(String id) async {
    items.removeWhere((e) => e.id == id);
    await _persist();
  }

  List<ClothingItem> byType(ClothingType type) =>
      items.where((e) => e.type == type).toList();

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'wardrobe_items',
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}
