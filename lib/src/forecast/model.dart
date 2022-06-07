import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

@immutable
class ForecastResponse {
  const ForecastResponse({
    required this.source,
    required this.productionCenter,
    required this.issue,
    required this.areas,
  });

  factory ForecastResponse.fromXmlDocument(XmlDocument xmlDocument) {
    final data = xmlDocument.getElement('data');
    if (data == null) {
      throw const ForecastParseException.missingElement(
        elementName: 'data',
      );
    }

    final source = data.forceGetAttribute('source');
    final productionCenter = data.forceGetAttribute('productioncenter');
    final forecast = data.forceGetElement('forecast');
    final issueStr =
        forecast.forceGetElement('issue').forceGetElement('timestamp');
    final issueDateTime = _parseForecastDateTimeString(issueStr.innerXml);
    final areasElement = forecast.findElements('area');

    return ForecastResponse(
      source: source,
      productionCenter: productionCenter,
      issue: issueDateTime,
      areas: areasElement.map((e) => ForecastArea.fromXmlElement(e)).toList(),
    );
  }

  final String source;
  final String productionCenter;
  final DateTime issue;
  final List<ForecastArea> areas;
}

@immutable
class ForecastArea {
  const ForecastArea.land({
    required this.id,
    required this.domain,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.humidity,
    required this.maxHumidity,
    required this.minHumidity,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weather,
    required this.windDirection,
    required this.windSpeed,
  }) : type = ForecastAreaType.land;

  const ForecastArea.sea({
    required this.id,
    required this.domain,
    required this.longitude,
    required this.latitude,
    required this.description,
  })  : type = ForecastAreaType.sea,
        humidity = const [],
        maxHumidity = const [],
        minHumidity = const [],
        temperature = const [],
        maxTemperature = const [],
        minTemperature = const [],
        weather = const [],
        windDirection = const [],
        windSpeed = const [];

  factory ForecastArea.fromXmlElement(XmlElement xmlElement) {
    final type = ForecastAreaType.values.byName(
      xmlElement.forceGetAttribute('type'),
    );
    final id = int.parse(xmlElement.forceGetAttribute('id'));
    final domain = xmlElement.forceGetAttribute('domain');
    final longitude = double.parse(xmlElement.forceGetAttribute('longitude'));
    final latitude = double.parse(xmlElement.forceGetAttribute('latitude'));
    final description = xmlElement.forceGetAttribute('description');
    final parameters = xmlElement.findElements('parameter');

    if (type == ForecastAreaType.sea) {
      return ForecastArea.sea(
        id: id,
        domain: domain,
        longitude: longitude,
        latitude: latitude,
        description: description,
      );
    }

    final humidity = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'hu',
    );
    final maxHumidity = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'humax',
    );
    final minHumidity = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'humin',
    );
    final temperature = parameters.firstWhere(
      (e) => e.getAttribute('id') == 't',
    );
    final maxTemperature = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'tmax',
    );
    final minTemperature = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'tmin',
    );
    final weather = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'weather',
    );
    final windDirection = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'wd',
    );
    final windSpeed = parameters.firstWhere(
      (e) => e.getAttribute('id') == 'ws',
    );

    return ForecastArea.land(
      id: id,
      domain: domain,
      longitude: longitude,
      latitude: latitude,
      description: description,
      humidity: humidity
          .findElements('timerange')
          .map((e) => Humidity.fromXmlElement(e))
          .toList(),
      maxHumidity: maxHumidity
          .findElements('timerange')
          .map((e) => Humidity.fromXmlElement(e))
          .toList(),
      minHumidity: minHumidity
          .findElements('timerange')
          .map((e) => Humidity.fromXmlElement(e))
          .toList(),
      temperature: temperature
          .findElements('timerange')
          .map((e) => Temperature.fromXmlElement(e))
          .toList(),
      maxTemperature: maxTemperature
          .findElements('timerange')
          .map((e) => Temperature.fromXmlElement(e))
          .toList(),
      minTemperature: minTemperature
          .findElements('timerange')
          .map((e) => Temperature.fromXmlElement(e))
          .toList(),
      weather: weather
          .findElements('timerange')
          .map((e) => Weather.fromXmlElement(e))
          .toList(),
      windDirection: windDirection
          .findElements('timerange')
          .map((e) => WindDirection.fromXmlElement(e))
          .toList(),
      windSpeed: windSpeed
          .findElements('timerange')
          .map((e) => WindSpeed.fromXmlElement(e))
          .toList(),
    );
  }

  final ForecastAreaType type;
  final int id;
  final String domain;
  final double longitude;
  final double latitude;
  final String description;
  final List<Humidity> humidity;
  final List<Humidity> maxHumidity;
  final List<Humidity> minHumidity;
  final List<Temperature> temperature;
  final List<Temperature> maxTemperature;
  final List<Temperature> minTemperature;
  final List<Weather> weather;
  final List<WindDirection> windDirection;
  final List<WindSpeed> windSpeed;
}

enum ForecastAreaType {
  land,
  sea,
}

@immutable
class WindSpeed {
  const WindSpeed({
    required this.dateTime,
    required this.type,
    required this.knots,
    required this.mph,
    required this.kph,
    required this.ms,
  });

  factory WindSpeed.fromXmlElement(XmlElement xmlElement) {
    final dateTimeStr = xmlElement.forceGetAttribute('datetime');
    final dateTime = _parseForecastDateTimeString(dateTimeStr);
    final typeStr = xmlElement.forceGetAttribute('type');
    final type = TimeRange.values.byName(typeStr);
    final values = xmlElement.findElements('value');

    final knotsStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'Kt').innerXml;
    final mphStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'MPH').innerXml;
    final kphStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'KPH').innerXml;
    final msStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'MS').innerXml;

    return WindSpeed(
      dateTime: dateTime,
      type: type,
      knots: double.parse(knotsStr),
      mph: double.parse(mphStr),
      kph: double.parse(kphStr),
      ms: double.parse(msStr),
    );
  }

  final DateTime dateTime;
  final TimeRange type;
  final double knots;
  final double mph;
  final double kph;
  final double ms;
}

@immutable
class WindDirection {
  const WindDirection({
    required this.dateTime,
    required this.type,
    required this.degree,
    required this.card,
    required this.sexa,
  });

  factory WindDirection.fromXmlElement(XmlElement xmlElement) {
    final dateTimeStr = xmlElement.forceGetAttribute('datetime');
    final dateTime = _parseForecastDateTimeString(dateTimeStr);
    final typeStr = xmlElement.forceGetAttribute('type');
    final type = TimeRange.values.byName(typeStr);
    final values = xmlElement.findElements('value');

    final degStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'deg').innerXml;
    final cardStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'CARD').innerXml;
    final sexaStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'SEXA').innerXml;

    return WindDirection(
      dateTime: dateTime,
      type: type,
      degree: double.parse(degStr),
      card: WindDirectionCard.fromCode(cardStr),
      sexa: int.parse(sexaStr),
    );
  }

  final DateTime dateTime;
  final TimeRange type;
  final double degree;
  final WindDirectionCard card;
  final int sexa;
}

enum WindDirectionCard {
  north(
    code: 'N',
    label: 'North',
  ),
  northNortheast(
    code: 'NNE',
    label: 'North-Northeast',
  ),
  northeast(
    code: 'NE',
    label: 'Northeast',
  ),
  eastNortheast(
    code: 'ENE',
    label: 'East-Northeast',
  ),
  east(
    code: 'E',
    label: 'East',
  ),
  eastSoutheast(
    code: 'ESE',
    label: 'East-Southeast',
  ),
  southeast(
    code: 'SE',
    label: 'Southeast',
  ),
  southSoutheast(
    code: 'SSE',
    label: 'South-Southeast',
  ),
  south(
    code: 'S',
    label: 'South',
  ),
  southSouthwest(
    code: 'SSW',
    label: 'South-Southwest',
  ),
  southwest(
    code: 'SW',
    label: 'Southwest',
  ),
  westSouthwest(
    code: 'WSW',
    label: 'West-Southwest',
  ),
  west(
    code: 'W',
    label: 'West',
  ),
  westNorthwest(
    code: 'WNW',
    label: 'West-Northwest',
  ),
  northWest(
    code: 'NW',
    label: 'Northwest',
  ),
  northNorthwest(
    code: 'NNW',
    label: 'North-Northwest',
  ),
  variable(
    code: 'VARIABLE',
    label: 'Variable',
  );

  const WindDirectionCard({
    required this.code,
    required this.label,
  });

  final String code;
  final String label;

  static WindDirectionCard fromCode(String code) {
    final value = _codeMap[code];
    if (value != null) return value;

    throw WindDirectionCardParseException(
      code: code,
    );
  }

  static Map<String, WindDirectionCard> _codeMap = {
    for (final e in WindDirectionCard.values) e.code: e,
  };
}

@immutable
class WindDirectionCardParseException implements Exception {
  const WindDirectionCardParseException({
    required this.code,
  });

  final String code;

  @override
  String toString() {
    return 'WindDirectionCardParseException: Unable to parse WindDirectionCard from code $code';
  }
}

@immutable
class Weather {
  const Weather({
    required this.dateTime,
    required this.type,
    required this.value,
  });

  factory Weather.fromXmlElement(XmlElement xmlElement) {
    final dateTimeStr = xmlElement.forceGetAttribute('datetime');
    final dateTime = _parseForecastDateTimeString(dateTimeStr);
    final typeStr = xmlElement.forceGetAttribute('type');
    final type = TimeRange.values.byName(typeStr);
    final valueStr = xmlElement.forceGetElement('value').innerXml;
    final value = WeatherCode.fromCode(int.parse(valueStr));

    return Weather(
      dateTime: dateTime,
      type: type,
      value: value,
    );
  }

  final DateTime dateTime;
  final TimeRange type;
  final WeatherCode value;
}

@immutable
class Temperature {
  const Temperature({
    required this.dateTime,
    required this.type,
    required this.celcius,
    required this.fahrenheit,
  });

  factory Temperature.fromXmlElement(XmlElement xmlElement) {
    final dateTimeStr = xmlElement.forceGetAttribute('datetime');
    final dateTime = _parseForecastDateTimeString(dateTimeStr);
    final typeStr = xmlElement.forceGetAttribute('type');
    final type = TimeRange.values.byName(typeStr);
    final values = xmlElement.findElements('value');
    final celciusStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'C').innerXml;
    final celcius = double.parse(celciusStr);
    final fahrenheitStr =
        values.firstWhere((e) => e.getAttribute('unit') == 'F').innerXml;
    final fahrenheit = double.parse(fahrenheitStr);

    return Temperature(
      dateTime: dateTime,
      type: type,
      celcius: celcius,
      fahrenheit: fahrenheit,
    );
  }

  final DateTime dateTime;
  final TimeRange type;
  final double celcius;
  final double fahrenheit;
}

@immutable
class Humidity {
  const Humidity({
    required this.dateTime,
    required this.value,
    required this.type,
  });

  factory Humidity.fromXmlElement(XmlElement xmlElement) {
    final dateTimeStr = xmlElement.forceGetAttribute('datetime');
    final dateTime = _parseForecastDateTimeString(dateTimeStr);
    final valueStr = xmlElement.forceGetElement('value').innerXml;
    final value = double.parse(valueStr);
    final typeStr = xmlElement.forceGetAttribute('type');
    final type = TimeRange.values.byName(typeStr);

    return Humidity(
      dateTime: dateTime,
      value: value,
      type: type,
    );
  }

  final DateTime dateTime;
  final double value;
  final TimeRange type;
}

enum TimeRange {
  hourly,
  daily,
}

enum WeatherCode {
  clearSkies(
    code: {0},
    label: 'Clear Skies',
    localLabel: 'Cerah',
  ),
  partlyCloudy(
    code: {1, 2},
    label: 'Partly Cloudy',
    localLabel: 'Cerah Berawan',
  ),
  mostlyCloudy(
    code: {3},
    label: 'Mostly Cloudy',
    localLabel: 'Berawan',
  ),
  overcast(
    code: {4},
    label: 'Overcast',
    localLabel: 'Berawan Tebal',
  ),
  haze(
    code: {5},
    label: 'Haze',
    localLabel: 'Udara Kabur',
  ),
  smoke(
    code: {10},
    label: 'Smoke',
    localLabel: 'Asap',
  ),
  fog(
    code: {45},
    label: 'Fog',
    localLabel: 'Kabut',
  ),
  lightRain(
    code: {60},
    label: 'Light Rain',
    localLabel: 'Hujan Ringan',
  ),
  rain(
    code: {61},
    label: 'Rain',
    localLabel: 'Hujan Sedang',
  ),
  heavyRain(
    code: {63},
    label: 'Heavy Rain',
    localLabel: 'Hujan Lebat',
  ),
  isolatedShower(
    code: {80},
    label: 'Isolated Shower',
    localLabel: 'Hujan Lokal',
  ),
  severeThunderstorm(
    code: {95, 97},
    label: 'Severe Thunderstorm',
    localLabel: 'Hujan Petir',
  );

  const WeatherCode({
    required this.code,
    required this.label,
    required this.localLabel,
  });

  final Set<int> code;
  final String label;
  final String localLabel;

  static WeatherCode fromCode(int code) {
    final value = _codeMap[code];
    if (value != null) return value;
    throw WeatherCodeParseException(code: code);
  }

  static Map<int, WeatherCode> _codeMap = {
    for (final v in WeatherCode.values) ...{
      for (final c in v.code) c: v,
    },
  };
}

@immutable
class WeatherCodeParseException implements Exception {
  const WeatherCodeParseException({
    required this.code,
  });

  final int code;

  @override
  String toString() {
    return 'WeatherCodeParseException: Unable to parse WeatherCode from code $code';
  }
}

@immutable
class ForecastParseException implements Exception {
  const ForecastParseException({
    required this.message,
  });

  const ForecastParseException.missingElement({
    required String elementName,
  }) : message = 'Unable to find element <$elementName>';

  const ForecastParseException.missingAttribute({
    required String elementName,
    required String attributeName,
  }) : message =
            'Unable to find attribute $attributeName for element <$elementName>';

  final String message;

  @override
  String toString() {
    return 'ForecastParseException: $message';
  }
}

extension _ForecastParserExtension on XmlElement {
  XmlElement forceGetElement(String name, {String? namespace}) {
    final result = getElement(name, namespace: namespace);
    if (result != null) return result;
    throw ForecastParseException.missingElement(elementName: name);
  }

  String forceGetAttribute(String name, {String? namespace}) {
    final result = getAttribute(name, namespace: namespace);
    if (result != null) return result;
    throw ForecastParseException.missingAttribute(
      elementName: this.name.local,
      attributeName: name,
    );
  }
}

DateTime _parseForecastDateTimeString(String str) {
  if (str.length == 12 || str.length == 14) {
    final year = int.parse(str.substring(0, 4));
    final month = int.parse(str.substring(4, 6));
    final day = int.parse(str.substring(6, 8));
    final hour = int.parse(str.substring(8, 10));
    final minute = int.parse(str.substring(10, 12));
    final second = str.length == 14 ? int.parse(str.substring(12, 14)) : 0;

    return DateTime.utc(year, month, day, hour, minute, second);
  }

  throw Exception(
    'Unable to parse string into DateTime (value: $str)',
  );
}
