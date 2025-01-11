import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/myapp/my_app.dart';
import '../../../../main.dart';
import '../screens/favorite_notes_screen.dart';
import '../providers/language_provider.dart';
import 'customdialog_about.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(l10n),
          _buildListTile(
            context,
            icon: Icons.share,
            title: l10n.share,
            onTap: () => _handleShare(context, l10n),
          ),
          _buildListTile(
            context,
            icon: Icons.favorite_border,
            title: l10n.don_favorites,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoriteNotesScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: l10n.about,
            onTap: () => _showDialog(
              context,
              title: l10n.about,
              message: l10n.aboutmsg,
              icon: Icons.info_outline,
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: l10n.help,
            onTap: () => _showDialog(
              context,
              title: l10n.help,
              message: l10n.contactwithus,
              icon: Icons.live_help_sharp,
            ),
          ),
          _buildCustomDivider(),
          _buildLanguageSwitcher(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(AppLocalizations l10n) {
    return DrawerHeader(
      decoration: const BoxDecoration(),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                l10n.title,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDivider() {
    return const Divider();
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.changeLanguage),
      onTap: () {
        _showLanguageDialog(context);
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 57, 57, 57),
          title: Center(child: Text(l10n.selectlanguage)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(l10n.english),
                onTap: () {
                  context
                      .read<LocaleProvider>()
                      .setLocale(const Locale('en', 'US'));
                  MyApp.setLocale(
                      context, const Locale('en', 'US')); // Update the locale
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(l10n.arabic),
                onTap: () {
                  context
                      .read<LocaleProvider>()
                      .setLocale(const Locale('ar', 'AE'));
                  MyApp.setLocale(
                      context, const Locale('ar', 'AE')); // Update the locale
                  Navigator.of(context).pop();
                },
              ),
              // Add more languages here as needed
            ],
          ),
        );
      },
    );
  }

  void _handleShare(BuildContext context, AppLocalizations l10n) {
    Share.share(
      l10n.shareme,
      subject: l10n.shareme,
    );
  }

  void _showDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    showDialog(

      context: context,
      builder: (context) {
        return CustomDialog(
          message: message,
          title: title,
          icon: icon,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }
}
