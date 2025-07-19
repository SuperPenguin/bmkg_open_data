// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  await _getWeather();
  await _getEarthquake();
}

Future<void> _getWeather() async {
  final requestUrl = Uri(
    scheme: 'https',
    host: 'api.bmkg.go.id',
    pathSegments: ['publik', 'prakiraan-cuaca'],
    queryParameters: {'adm4': '31.71.01.1001'},
  );

  final response = await http.get(requestUrl);
  if (response.statusCode != 200) {
    throw Exception('$requestUrl HTTP ${response.statusCode}');
  }
  final content = response.body;

  final file = File('test_resources/weather/weather.json');
  await file.create(recursive: true);
  print('Writing to ${file.path}');
  await file.writeAsString(content);
}

Future<void> _getEarthquake() async {
  final baseUrl = Uri(
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
    final requestUrl = baseUrl.replace(
      pathSegments: [
        ...baseUrl.pathSegments,
        endpoint,
      ],
    );

    print('Requesting: $requestUrl');
    final response = await http.get(requestUrl);
    if (response.statusCode != 200) {
      throw Exception('$requestUrl HTTP ${response.statusCode}');
    }
    final content = response.body;

    final file = File('test_resources/earthquake/$endpoint');
    print('Writing to ${file.path}');
    await file.create(recursive: true);
    await file.writeAsString(content);
  }
}
