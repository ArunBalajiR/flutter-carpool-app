import 'package:url_launcher/url_launcher.dart';


openPhone(url) async {
  url = 'tel: ' + url;
  if (await canLaunch(url) && url != '') {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}