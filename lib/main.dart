import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:hauptwerk_hub/components/midi_devices.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MidiCommand()
    ..addVirtualDevice(name: 'Mixtuur')
    ..addVirtualDevice(name: 'Mixtuur 2')
    ..addVirtualDevice(name: 'Mixtuur 3');

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hauptwerk Hub'),
      ),
      body: const Center(child: MidiDevices()),
    );
  }
}
