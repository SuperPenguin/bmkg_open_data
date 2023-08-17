// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:io';

import 'package:bmkg_open_data/bmkg_open_data.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Forecast
  for (final place in ForecastPlace.values) {
    final requestUri = Uri(
      scheme: 'https',
      host: 'data.bmkg.go.id',
      pathSegments: [
        'DataMKG',
        'MEWS',
        'DigitalForecast',
        place.fileName,
      ],
    );
    print('Requesting: $requestUri');
    final response = await http.get(requestUri);
    final content = response.body;

    final file = File('test_resources/forecast/${place.fileName}');
    print('Writing to ${file.path}');
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  // Earthquake
  final earthquakeBaseUri = Uri(
    scheme: 'https',
    host: 'data.bmkg.go.id',
    pathSegments: [
      'DataMKG',
      'TEWS',
    ],
  );

  const List<String> earthquakeEndpoints = [
    'autogempa.json',
    'gempaterkini.json',
    'gempadirasakan.json',
  ];

  for (final endpoint in earthquakeEndpoints) {
    final requestUri = earthquakeBaseUri.replace(
      pathSegments: [
        ...earthquakeBaseUri.pathSegments,
        endpoint,
      ],
    );

    print('Requesting: $requestUri');
    final response = await http.get(requestUri);
    final content = response.body;

    final file = File('test_resources/earthquake/$endpoint');
    print('Writing to ${file.path}');
    await file.create(recursive: true);
    await file.writeAsString(content);
  }
}
