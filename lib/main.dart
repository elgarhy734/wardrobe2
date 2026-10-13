import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models.dart';
import 'add_item_screen.dart';
import 'wardrobe_screen.dart';
import 'outfit_screen.dart';

void main() {
  runApp(const WardrobeApp());
}

class WardrobeApp extends StatefulWidget {
  const WardrobeApp({super.key});

  @override
  State<WardrobeApp> createState() => _WardrobeAppState();
}

class _WardrobeAppState extends State<WardrobeApp> {
  final Wardrobe wardrobe = Wardrobe();

  @override
  void initState() {
    super.initState();
    _loadWardrobe();
  }

  Future<void> _loadWardrobe() async {
    await wardrobe.load();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دولابي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      home: HomePage(wardrobe: wardrobe),
    );
  }
}

class HomePage extends StatefulWidget {
  final Wardrobe wardrobe;
  const HomePage({super.key, required this.wardrobe});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      WardrobeScreen(wardrobe: widget.wardrobe),
      OutfitScreen(wardrobe: widget.wardrobe),
      AddItemScreen(
        wardrobe: widget.wardrobe,
        onSaved: () => setState(() => _index = 0),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checkroom), label: 'الدولاب'),
          NavigationDestination(icon: Icon(Icons.style), label: 'طقمي'),
          NavigationDestination(icon: Icon(Icons.add_a_photo), label: 'إضافة'),
        ],
      ),
    );
  }
}
