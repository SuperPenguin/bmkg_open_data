import 'dart:io';

import 'package:bmkg_open_data/bmkg_open_data.dart';
import 'package:bmkg_open_data/src/client.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    overrideClient(_createMockClient);
  });

  test('Parse All ForecastResponse', () async {
    for (final place in ForecastPlace.values) {
      final future = getForecast(place: place);
      await expectLater(future, completion(isA<ForecastResponse>()));
    }
  });

  test('Parse Last Earthquake', () async {
    final future = getLastEarthquake();
    await expectLater(future, completion(isA<LastEarthquake>()));
  });

  test('Parse Recent Earthquake', () async {
    final future = getRecentEarthquake();
    await expectLater(future, completion(isA<List<RecentEarthquake>>()));
  });

  test('Parse Earthquake Felt', () async {
    final future = getEarthquakeFelt();
    await expectLater(future, completion(isA<List<EarthquakeFelt>>()));
  });
}

Client _createMockClient() {
  final client = MockClient((request) async {
    final url = request.url;

    if (_isForecastPath(url.pathSegments)) {
      final fileName = url.pathSegments[3];
      final file = File('test_resources/forecast/$fileName');
      final content = await file.readAsString();

      return Response(
        content,
        200,
        headers: {
          'content-type': 'text/xml',
        },
      );
    } else if (_isEarthquakePath(url.pathSegments)) {
      final fileName = url.pathSegments[2];
      final file = File('test_resources/earthquake/$fileName');
      final content = await file.readAsString();

      return Response(
        content,
        200,
        headers: {
          'content-type': 'application/json',
        },
      );
    } else {
      return Response('', 404);
    }
  });

  return client;
}

bool _isForecastPath(List<String> pathSegments) {
  return pathSegments.length == 4 &&
      pathSegments[0] == 'DataMKG' &&
      pathSegments[1] == 'MEWS' &&
      pathSegments[2] == 'DigitalForecast';
}

bool _isEarthquakePath(List<String> pathSegments) {
  return pathSegments.length == 3 &&
      pathSegments[0] == 'DataMKG' &&
      pathSegments[1] == 'TEWS';
}
