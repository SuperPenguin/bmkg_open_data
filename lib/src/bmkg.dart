import 'dart:convert';

import 'package:bmkg_open_data/src/earthquake.dart';
import 'package:bmkg_open_data/src/http_client.dart';
import 'package:bmkg_open_data/src/weather.dart';

final class Bmkg {
  const Bmkg({
    BmkgHttpClient httpClient = const DefaultBmkgHttpClient(),
  }) : _httpClient = httpClient;

  final BmkgHttpClient _httpClient;

  static final Uri baseUrl = Uri(
    scheme: 'https',
    host: 'data.bmkg.go.id',
  );

  Future<LastEarthquake> getLastEarthquake() async {
    final requestUrl = baseUrl.replace(
      pathSegments: [
        'DataMKG',
        'TEWS',
        'autogempa.json',
      ],
    );

    final response = await _httpClient.get(requestUrl);

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> earthquake = (jsonResponse['Infogempa']
        as Map<String, dynamic>)['gempa'] as Map<String, dynamic>;

    return LastEarthquake.fromJson(earthquake);
  }

  Future<List<EarthquakeFelt>> getEarthquakeFelt() async {
    final requestUrl = baseUrl.replace(
      pathSegments: [
        'DataMKG',
        'TEWS',
        'gempadirasakan.json',
      ],
    );

    final response = await _httpClient.get(requestUrl);

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> earthquakes = (jsonResponse['Infogempa']
        as Map<String, dynamic>)['gempa'] as List<dynamic>;

    return earthquakes
        .map((e) => EarthquakeFelt.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RecentEarthquake>> getRecentEarthquake() async {
    final requestUrl = baseUrl.replace(
      pathSegments: [
        'DataMKG',
        'TEWS',
        'gempaterkini.json',
      ],
    );

    final response = await _httpClient.get(requestUrl);

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> earthquakes = (jsonResponse['Infogempa']
        as Map<String, dynamic>)['gempa'] as List<dynamic>;

    return earthquakes
        .map((e) => RecentEarthquake.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WeatherForecast> getWeatherForecast({required String adm4}) async {
    final requestUrl = Uri(
      scheme: 'https',
      host: 'api.bmkg.go.id',
      pathSegments: [
        'publik',
        'prakiraan-cuaca',
      ],
      queryParameters: {
        'adm4': adm4,
      },
    );

    final response = await _httpClient.get(requestUrl);
    return WeatherForecast.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
