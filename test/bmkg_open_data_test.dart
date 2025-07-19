import 'dart:io';

import 'package:bmkg_open_data/bmkg_open_data.dart';
import 'package:http/src/response.dart';
import 'package:http/testing.dart';

import 'package:test/test.dart';

void main() {
  late Bmkg bmkg;

  setUpAll(() {
    bmkg = Bmkg(httpClient: _BmkgMockClient());
  });

  test('Parse Weather Forecast', () async {
    final future = bmkg.getWeatherForecast(adm4: '31.71.01.1001');
    await expectLater(future, completion(isA<WeatherForecast>()));
  });

  test('Parse Last Earthquake', () async {
    final future = bmkg.getLastEarthquake();
    await expectLater(future, completion(isA<LastEarthquake>()));
  });

  test('Parse Recent Earthquake', () async {
    final future = bmkg.getRecentEarthquake();
    await expectLater(future, completion(isA<List<RecentEarthquake>>()));
  });

  test('Parse Earthquake Felt', () async {
    final future = bmkg.getEarthquakeFelt();
    await expectLater(future, completion(isA<List<EarthquakeFelt>>()));
  });
}

class _BmkgMockClient extends BmkgHttpClient {
  _BmkgMockClient();

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    final client = MockClient((request) async {
      final url = request.url;
      final Map<String, dynamic> urlData = {
        'host': url.host,
        'paths': url.pathSegments.toList(),
      };

      if (urlData
          case {
            'host': 'data.bmkg.go.id',
            'paths': ['DataMKG', 'TEWS', String method]
          }) {
        final file = File('test_resources/earthquake/$method');
        final content = await file.readAsString();

        return Response(
          content,
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      }

      if (urlData
          case {
            'host': 'api.bmkg.go.id',
            'paths': ['publik', 'prakiraan-cuaca']
          }) {
        final file = File('test_resources/weather/weather.json');
        final content = await file.readAsString();

        return Response(
          content,
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      }

      return Response('', 404);
    });

    try {
      return await client.get(url, headers: headers);
    } finally {
      client.close();
    }
  }
}
