import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:hauptwerk_hub/components/switch_card.dart';

class MidiDeviceList extends StatelessWidget {
  final List<MidiDevice> devices;
  final void Function(MidiDevice)? onConnect;
  final void Function(MidiDevice)? onDisconnect;

  const MidiDeviceList({
    super.key,
    required this.devices,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (devices.isEmpty) {
      return Text(
        'No MIDI devices connected',
        style: theme.textTheme.displaySmall?.copyWith(
          color: theme.textTheme.displaySmall?.color?.withValues(alpha: 0.7),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        for (final device in devices)
          SizedBox(
            width: 220,
            child: SwitchCard(
              isEnabled: device.connected,
              enabledLabel: const Text('Connect'),
              disabledLabel: const Text('Disconnect'),
              onEnabled: () {
                onConnect?.call(device);
              },
              onDisabled: () {
                onDisconnect?.call(device);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: device.name,
                    child: Text(
                      device.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    device.id,
                    style: theme.textTheme.labelSmall,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
