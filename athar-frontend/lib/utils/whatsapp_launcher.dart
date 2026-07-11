import 'package:url_launcher/url_launcher.dart';

class WhatsappLauncher {
  static Future<bool> open(String phoneNumber, {String? message}) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    final url = 'https://wa.me/$cleanNumber${message != null ? '?text=$encodedMessage' : ''}';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}