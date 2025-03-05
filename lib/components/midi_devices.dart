import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiDevices extends StatelessWidget {
  const MidiDevices({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text('Select MIDI device'),
        onPressed: () async {
          final device = (await MidiCommand().devices)?.firstOrNull;
          if (device == null) return;

          try {
            await MidiCommand().connectToDevice(device);
          } on PlatformException catch (e) {
            if (e.message != 'Device already connected') rethrow;
          }
        },
      ),
    );
  }
}
