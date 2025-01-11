import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onClose;
  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                message!,
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onClose,
                  child: Text(l10n.cancel),
                ),
                // ElevatedButton(
                //   onPressed: _contactViaWhatsApp,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //   ),
                //   child: const Icon(Icons.call, color: Colors.white),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _contactViaWhatsApp() async {
    const String phoneNumber = '967717281413';
    final String encodedMessage = Uri.encodeComponent(message ?? '');
    final Uri whatsappUri =
    Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }
}
