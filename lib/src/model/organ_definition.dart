import 'package:xml/xml.dart';

final imageGallery = {
  'St. Maximin Demo': [
    'https://www.sonusparadisi.cz/media/Foto/16-organ/6_16-maximin14.jpg',
  ],
  'Caen Surround': [
    'https://www.sonusparadisi.cz/media/Foto/13-organ/3_13-caen4.jpg',
  ],
  'Caen Dry': [
    'https://www.sonusparadisi.cz/media/Foto/13-organ/3_13-caen4.jpg',
  ],
};

final class OrganDefinition {
  final ({String uniqueOrganID, String name}) identification;
  final ({String? location, String? builder, String? buildDate}) organInfo;

  const OrganDefinition({
    required this.identification,
    required this.organInfo,
  });

  List<String> get images => imageGallery[identification.name] ?? const [];

  static OrganDefinition? fromXML(XmlDocument document) {
    final general = document.findAllElements('_General').firstOrNull;
    if (general == null) return null;

    return OrganDefinition(
      identification: (
        uniqueOrganID:
            general
                .findElements('Identification_UniqueOrganID')
                .single
                .innerText,
        name: general.findElements('Identification_Name').single.innerText,
      ),
      organInfo: (
        location: general.findElements('OrganInfo_Location').single.innerText,
        builder: general.findElements('OrganInfo_Builder').single.innerText,
        buildDate: general.findElements('OrganInfo_BuildDate').single.innerText,
      ),
    );
  }

  @override
  String toString() => 'OrganDefinition$identification';
}
