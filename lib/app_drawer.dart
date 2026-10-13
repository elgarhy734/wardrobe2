import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const String developerName = 'حازم الجرحي';
  static const String whatsappDisplay = '01221085824';
  static const String whatsappLink = 'https://wa.me/201221085824';

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse(whatsappLink);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('مفيش واتساب على الموبايل ده')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.teal.shade400, Colors.teal.shade800],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.checkroom, color: Colors.teal, size: 32),
                ),
                SizedBox(height: 10),
                Text(
                  'دولابي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'دولابك الافتراضي ومنسق أطقمك',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'عن المبرمج',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 14,
              ),
            ),
          ),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(developerName),
            subtitle: Text('مبرمج التطبيق'),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.phone)),
            title: const Text('واتساب'),
            subtitle: Text(whatsappDisplay),
            trailing: FilledButton.icon(
              onPressed: () => _openWhatsApp(context),
              icon: const Icon(Icons.chat, size: 18),
              label: const Text('راسلني'),
            ),
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'دولابي',
            applicationVersion: '1.1.0',
            applicationLegalese: '© 2026 حازم الجرحي',
            child: Text('عن التطبيق'),
          ),
        ],
      ),
    );
  }
}
