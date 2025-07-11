// ignore_for_file: avoid_print

import 'package:bmkg_open_data/bmkg_open_data.dart';

Future<void> main() async {
  const bmkg = Bmkg();

  // WEATHER FORECAST
  final sb0 = StringBuffer();
  final weatherForecast = await bmkg.getWeatherForecast(adm4: '31.71.01.1001');
  sb0.writeln('Location');
  sb0.writeln('Administrative Code: ${weatherForecast.location.adm4}');
  sb0.writeln(
    '${weatherForecast.location.desa}, ${weatherForecast.location.kecamatan}, ${weatherForecast.location.kotkab}, ${weatherForecast.location.provinsi}',
  );
  sb0.writeln('Time: ${weatherForecast.data.first.dateTime.toLocal()}');
  sb0.writeln('Temperature: ${weatherForecast.data.first.t} C');

  print(sb0.toString());

  // LAST EARTHQUAKE
  final sb1 = StringBuffer();
  final lastEarthquake = await bmkg.getLastEarthquake();
  sb1.writeln('Last Earthquake');
  sb1.writeln('DateTime: ${lastEarthquake.dateTime}');
  sb1.writeln(
    'Coordinate: ${lastEarthquake.latitude}, ${lastEarthquake.longitude}',
  );
  sb1.writeln('Magnitude: ${lastEarthquake.magnitude}');
  sb1.writeln('Depth: ${lastEarthquake.depth}');
  sb1.writeln('Region: ${lastEarthquake.region}');
  sb1.writeln('Potency: ${lastEarthquake.potency}');
  sb1.writeln('Region Felt: ${lastEarthquake.regionFelt}');
  sb1.writeln('Shakemap Uri: ${lastEarthquake.shakemapUri}');
  print(sb1.toString());

  // RECENT EARTHQUAKE
  final sb2 = StringBuffer();
  final recentEarthquake = await bmkg.getRecentEarthquake();
  sb2.writeln('Recent Earthquake');
  for (final e in recentEarthquake) {
    sb2.writeln('DateTime: ${e.dateTime}');
    sb2.writeln(
      'Coordinate: ${e.latitude}, ${e.longitude}',
    );
    sb2.writeln('Magnitude: ${e.magnitude}');
    sb2.writeln('Depth: ${e.depth}');
    sb2.writeln('Region: ${e.region}');
    sb2.writeln('Potency: ${e.potency}');
    sb2.writeln('');
  }
  print(sb2.toString());

  // EARTHQUAKE FELT
  final sb3 = StringBuffer();
  final earthquakeFelt = await bmkg.getEarthquakeFelt();
  sb3.writeln('Recent Earthquake');
  for (final e in earthquakeFelt) {
    sb3.writeln('DateTime: ${e.dateTime}');
    sb3.writeln(
      'Coordinate: ${e.latitude}, ${e.longitude}',
    );
    sb3.writeln('Magnitude: ${e.magnitude}');
    sb3.writeln('Depth: ${e.depth}');
    sb3.writeln('Region: ${e.region}');
    sb1.writeln('Region Felt: ${lastEarthquake.regionFelt}');
    sb3.writeln('');
  }
  print(sb3.toString());
}
