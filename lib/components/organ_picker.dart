import 'dart:developer' show inspect;
import 'dart:isolate' show Isolate;

import 'package:flutter/material.dart';
import 'package:hauptwerk_hub/components/organ_grid.dart';
import 'package:hauptwerk_hub/model.dart';

class OrganPicker extends StatefulWidget {
  const OrganPicker({super.key});

  @override
  State<OrganPicker> createState() => _OrganPickerState();
}

class _OrganPickerState extends State<OrganPicker> {
  late final organDefinitions = Isolate.run(Hauptwerk.organDefinitions);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: organDefinitions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          inspect(snapshot.error);
          return const Text('No organ definitions found.');
        }

        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }

        return switch (snapshot.connectionState) {
          ConnectionState.none => const Text('No organ definitions found.'),
          ConnectionState.waiting => const CircularProgressIndicator(),
          ConnectionState.active || ConnectionState.done =>
            SingleChildScrollView(child: OrganGrid(organs: snapshot.data!)),
        };
      },
    );
  }
}
