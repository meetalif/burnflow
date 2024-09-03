import 'package:burnflow/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waveui/waveui.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width > 800 ? 700 : null,
      child: Column(
        children: [
          ListTile(
            tileColor: Colors.red.withOpacity(0.1),
            title: const Text(
              "This App is in development stages. Please use proper caution and clinical judgement to proceed further.",
              style: TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Tooltip(
              message: "Developed by Md Waliul Islam Alif",
              child: ListTile(
                onTap: () => launchUrl(Uri.parse(DEVELOPER_URL)),
                title: Text(
                  "Copyright 2024 • All right reserved",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
