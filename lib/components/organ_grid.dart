import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:hauptwerk_hub/model.dart';

class OrganGrid extends StatefulWidget {
  final List<OrganDefinition> organs;

  const OrganGrid({super.key, required this.organs});

  @override
  State<OrganGrid> createState() => _OrganGridState();
}

final class OrganCard {
  final String label;
  final List<String> images;
  final List<(OrganDefinition organ, {String label})> organs;

  OrganCard({required this.label, required this.organs, required this.images});
}

class _OrganGridState extends State<OrganGrid> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        for (final card in widget.organs.fold(<OrganCard>[], (prev, organ) {
          final name = organ.identification.name;
          final index = name.lastIndexOf(RegExp('[ .]'));

          final last = index == -1 ? name : name.substring(index + 1).trim();
          var label = 'Open';
          var organLabel = name;

          if (last.toLowerCase()
              case 'dry' || 'surround' || 'demo' || 'extended') {
            label = last.replaceAll(RegExp('[()]'), '');
            organLabel = name.substring(0, index).trim();
          }

          if (prev.isNotEmpty &&
              name.startsWith(
                prev.last.organs.first.$1.identification.name.split(' ').first,
              )) {
            return prev..last.organs.add((organ, label: label));
          }
          return prev..add(
            OrganCard(
              label: organLabel,
              organs: [(organ, label: label)],
              images: organ.images,
            ),
          );
        }))
          SizedBox(
            height: 320,
            width: 480,
            child: Card(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Column(
                  spacing: 4,
                  children: [
                    if (card.images.isNotEmpty)
                      Image.network(
                        card.images.first,
                        fit: BoxFit.cover,
                        height: 200,
                        width: 480,
                      )
                    else
                      SizedBox(
                        height: 200,
                        width: 480,
                        child: Icon(Icons.image, color: theme.hintColor),
                      ),
                    Text(card.label, textAlign: TextAlign.center),
                    if (card.organs.first.$1.organInfo.builder != null)
                      Text(
                        card.organs.first.$1.organInfo.builder!.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.textTheme.labelMedium?.color?.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (card.organs.first.$1.organInfo.buildDate != null)
                      Text(
                        card.organs.first.$1.organInfo.buildDate!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.labelSmall?.color?.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        for (final label in card.organs)
                          Tooltip(
                            message: label.$1.identification.name,
                            child: TextButton(
                              onPressed: () async {
                                await Hauptwerk.setMostRecentlyUsedOrgan(
                                  label.$1,
                                );
                                MidiCommand().sendData(
                                  Uint8List.fromList(const [0xB0, 64, 127]),
                                );
                              },
                              child: Text(label.label),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
