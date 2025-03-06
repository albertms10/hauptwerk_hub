import 'package:flutter/material.dart';
import 'package:hauptwerk_hub/components/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HauptwerkHubApp());
}

class HauptwerkHubApp extends StatelessWidget {
  const HauptwerkHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hauptwerk Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
