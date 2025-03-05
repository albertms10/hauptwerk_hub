import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:hauptwerk_hub/components/midi_device_list.dart';

class MidiDevices extends StatelessWidget {
  const MidiDevices({super.key});

  Future<void> _disconnectDevice(MidiDevice device) async {
    MidiCommand().disconnectDevice(device);
  }

  Future<void> _connectToDevice(MidiDevice device) async {
    try {
      await MidiCommand().connectToDevice(device);
    } on PlatformException catch (e) {
      if (e.message != 'Device already connected') rethrow;
    }
  }

  void _sendMidiCommand() {
    MidiCommand().sendData(Uint8List.fromList(const [0xB0, 64, 127]));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: MidiCommand().onMidiSetupChanged,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'An error has occurred while trying to inspect MIDI devices.',
          );
        }

        return switch (snapshot.connectionState) {
          ConnectionState.done ||
          ConnectionState.none => const Text('Connection closed'),
          ConnectionState.waiting || ConnectionState.active => FutureBuilder(
            future: MidiCommand().devices,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Row(
                  spacing: 24,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(),
                    ),
                    Text(
                      'Waiting for MIDI devices…',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                );
              }

              final devices =
                  snapshot.data!..sort((a, b) => a.name.compareTo(b.name));

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  MidiDeviceList(
                    devices: devices,
                    onConnect: _connectToDevice,
                    onDisconnect: _disconnectDevice,
                  ),
                  TextButton(
                    onPressed: _sendMidiCommand,
                    child: const Text('Send MIDI command'),
                  ),
                ],
              );
            },
          ),
        };
      },
    );
  }
}
