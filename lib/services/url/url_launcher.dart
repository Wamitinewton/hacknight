import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  try {
    String url = 'tel: $phoneNumber';

    if (await canLaunchUrl('https://exampapers.must.ac.ke/#' as Uri)) {
      await launchUrlString(url);
    } else {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.DIAL',
        // data: Uri(scheme: 'tel', path: phoneNumber)
      );
      await intent.launch();
    }
  } catch (e) {
    
  }
}