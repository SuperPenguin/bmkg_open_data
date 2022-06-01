import 'package:bmkg_open_data/bmkg_open_data.dart';

Future<void> main() async {
  // FORECAST
  for (final place in ForecastPlace.values) {
    final forecast = await getForecast(place: place);
    final sb = StringBuffer();

    sb.writeln(place);
    sb.writeln(forecast.source);
    sb.writeln(forecast.productionCenter);
    sb.writeln(forecast.issue);
    sb.writeln('');

    for (final area in forecast.areas) {
      sb.writeln('ID: ${area.id} DOMAIN: ${area.domain}');

      sb.writeln('Humidity');
      for (final h in area.humidity) {
        sb.writeln('  [${h.dateTime}] ${h.value}');
      }

      sb.writeln('Max Humidity');
      for (final maxh in area.maxHumidity) {
        sb.writeln('  [${maxh.dateTime}] ${maxh.value}');
      }

      sb.writeln('Min Humidity');
      for (final minh in area.minHumidity) {
        sb.writeln('  [${minh.dateTime}] ${minh.value}');
      }

      sb.writeln('Temperature');
      for (final h in area.temperature) {
        sb.writeln('  [${h.dateTime}] ${h.celcius}');
      }

      sb.writeln('Max Temperature');
      for (final maxh in area.maxTemperature) {
        sb.writeln('  [${maxh.dateTime}] ${maxh.celcius}');
      }

      sb.writeln('Min Temperature');
      for (final minh in area.minTemperature) {
        sb.writeln('  [${minh.dateTime}] ${minh.celcius}');
      }

      sb.writeln('Weather');
      for (final w in area.weather) {
        sb.writeln('  [${w.dateTime}] ${w.value}');
      }

      sb.writeln('Wind Direction');
      for (final w in area.windDirection) {
        sb.writeln(
          '  [${w.dateTime}] DEG: ${w.degree}, CARD: ${w.card}, SEXA: ${w.sexa}',
        );
      }

      sb.writeln('Wind Speed');
      for (final w in area.windSpeed) {
        sb.writeln(
          '  [${w.dateTime}] Kts: ${w.knots} MPH: ${w.mph} KPH: ${w.kph} MS: ${w.ms}',
        );
      }

      sb.writeln('');
    }

    print(sb.toString());
  }

  // LAST EARTHQUAKE
  final sb1 = StringBuffer();
  final lastEarthquake = await getLastEarthquake();
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
  final recentEarthquake = await getRecentEarthquake();
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
  final earthquakeFelt = await getEarthquakeFelt();
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
