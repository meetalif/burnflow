import 'package:burnflow/pages/home_page.dart';
import 'package:waveui/waveui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: WaveTheme(themeColor: Colors.blue),
      defaultTransition: Transition.noTransition,
      home: const HomePage(),
    );
  }
}


// flutter build web --web-renderer canvaskit