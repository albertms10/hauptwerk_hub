//
// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io' show Directory, File, Platform;

import 'package:hauptwerk_hub/model.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

final class Hauptwerk {
  static Future<List<OrganDefinition>> organDefinitions() async {
    final files = await _readOrganDefinitionFiles();

    final organDefinitions = <OrganDefinition>[];
    for (final file in files) {
      final xmlString = await file.readAsString();
      final organDefinition = OrganDefinition.fromXML(
        XmlDocument.parse(xmlString),
      );
      if (organDefinition != null) organDefinitions.add(organDefinition);
    }

    return organDefinitions
      ..sort((a, b) => a.identification.name.compareTo(b.identification.name));
  }

  static const _mostRecentlyUsedKey = 'mruorgsh01';
  static final _mostRecentlyUsedRegExp = RegExp(
    '(<$_mostRecentlyUsedKey>)(.*?)(</$_mostRecentlyUsedKey>)',
    dotAll: true,
  );

  static Future<void> setMostRecentlyUsedOrgan(
    OrganDefinition organDefinition,
  ) async {
    final configFile = await _readGeneralSettingsFile();
    final xmlString = await configFile.readAsString();

    if (!_mostRecentlyUsedRegExp.hasMatch(xmlString)) {
      throw StateError('Element <$_mostRecentlyUsedKey> not found.');
    }

    final updatedXml = xmlString.replaceAllMapped(_mostRecentlyUsedRegExp, (
      match,
    ) {
      return '${match.group(1)}'
          '${organDefinition.identification.name}'
          '${match.group(3)}';
    });

    await configFile.writeAsString(updatedXml);
  }

  static Future<File> _readGeneralSettingsFile() async {
    final generalSettingsDirectory = _directory(
      'HauptwerkUserData/Config0-GeneralSettings',
    );
    final configFile = File(
      '${generalSettingsDirectory.path}/Config.Config_Hauptwerk_xml',
    );
    if (!configFile.existsSync()) {
      throw StateError('File not found ${configFile.path}.');
    }

    return configFile;
  }

  static Future<List<File>> _readOrganDefinitionFiles() async {
    final organDefinitionsDirectory = _directory(
      'HauptwerkSampleSetsAndComponents/OrganDefinitions',
    );

    if (!organDefinitionsDirectory.existsSync()) {
      throw StateError(
        'Organ definitions directory does not exist: '
        '${organDefinitionsDirectory.path}',
      );
    }

    return organDefinitionsDirectory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.Organ_Hauptwerk_xml'))
        .toList();
  }

  static Directory _directory(String pathname) {
    final String root;
    if (Platform.isMacOS) {
      root = Platform.environment['HOME']!.split('/').take(3).join('/');
    } else if (Platform.isWindows) {
      root = Platform.environment['USERPROFILE']!.split('/').take(3).join('/');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    return Directory(path.join('', root, 'Hauptwerk', pathname));
  }
}
