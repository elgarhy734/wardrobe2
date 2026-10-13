import 'dart:convert';
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'models.dart';

class WardrobeScreen extends StatefulWidget {
  final Wardrobe wardrobe;
  const WardrobeScreen({super.key, required this.wardrobe});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  ClothingType? filter;

  @override
  Widget build(BuildContext context) {
    final items =
        filter == null ? widget.wardrobe.items : widget.wardrobe.byType(filter!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('دولابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('اضغط مطولاً على أي قطعة لمسحها من الدولاب'),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                _filterChip(null, 'الكل'),
                ...ClothingType.values.map((t) => _filterChip(t, t.label)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checkroom_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'الدولاب فاضي لسه\nصور أول قطعة من تبويب "إضافة"',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _itemCard(items[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(ClothingType? type, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: filter == type,
        onSelected: (_) => setState(() => filter = type),
      ),
    );
  }

  Widget _itemCard(ClothingItem item) {
    return GestureDetector(
      onLongPress: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('مسح القطعة؟'),
            content: Text('هتمسح "${item.displayType}" باللون ${item.colorName}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('امسح'),
              ),
            ],
          ),
        );
        if (ok == true) {
          await widget.wardrobe.remove(item.id);
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(item.colorValue), width: 3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Column(
            children: [
              Expanded(
                child: Image.memory(
                  base64Decode(item.imageBase64),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${item.displayType} • ${item.colorName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
