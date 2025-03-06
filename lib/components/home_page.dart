import 'package:flutter/material.dart';
import 'package:hauptwerk_hub/components/midi_devices.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hauptwerk Hub'),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Center(child: MidiDevices()),
      ),
    );
  }
}
