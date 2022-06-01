import 'dart:convert';

import 'package:bmkg_open_data/src/client.dart';
import 'package:bmkg_open_data/src/earthquake/model.dart';

// https://data.bmkg.go.id/DataMKG/TEWS/
final Uri _baseUri = baseBmkgUri.replace(
  pathSegments: ['DataMKG', 'TEWS'],
);

final Uri _lastEarthquakeUri = _baseUri.replace(
  pathSegments: [
    ..._baseUri.pathSegments,
    'autogempa.json',
  ],
);

Future<LastEarthquake> getLastEarthquake() async {
  final response = await clientGet(_lastEarthquakeUri);
  final jsonObj = jsonDecode(response.body) as Map<String, dynamic>;
  final earthquakeObj = (jsonObj['Infogempa'] as Map<String, dynamic>)['gempa']
      as Map<String, dynamic>;

  return LastEarthquake.fromJson(earthquakeObj);
}

final Uri _earthquakeFeltUri = _baseUri.replace(
  pathSegments: [
    ..._baseUri.pathSegments,
    'gempadirasakan.json',
  ],
);

Future<List<EarthquakeFelt>> getEarthquakeFelt() async {
  final response = await clientGet(_earthquakeFeltUri);
  final jsonObj = jsonDecode(response.body) as Map<String, dynamic>;
  final earthquakeList =
      (jsonObj['Infogempa'] as Map<String, dynamic>)['gempa'] as List<dynamic>;

  return [
    for (final obj in earthquakeList)
      EarthquakeFelt.fromJson(obj as Map<String, dynamic>),
  ];
}

final Uri _recentEarthquakeUri = _baseUri.replace(
  pathSegments: [
    ..._baseUri.pathSegments,
    'gempaterkini.json',
  ],
);

Future<List<RecentEarthquake>> getRecentEarthquake() async {
  final response = await clientGet(_recentEarthquakeUri);
  final jsonObj = jsonDecode(response.body) as Map<String, dynamic>;
  final earthquakeList =
      (jsonObj['Infogempa'] as Map<String, dynamic>)['gempa'] as List<dynamic>;

  return [
    for (final obj in earthquakeList)
      RecentEarthquake.fromJson(obj as Map<String, dynamic>),
  ];
}
