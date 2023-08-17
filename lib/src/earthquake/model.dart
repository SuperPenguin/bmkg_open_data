import 'package:meta/meta.dart';

@immutable
sealed class Earthquake {
  const Earthquake({
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.magnitude,
    required this.depth,
    required this.region,
  });

  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final double magnitude;
  final String depth;
  final String region;
}

@immutable
final class LastEarthquake extends Earthquake {
  const LastEarthquake({
    required super.dateTime,
    required super.latitude,
    required super.longitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.potency,
    required this.regionFelt,
    required this.shakemap,
  });

  factory LastEarthquake.fromJson(Map<String, dynamic> json) {
    final (latitude, longitude) = _parseCoordinate(
      json['Coordinates'] as String,
    );

    return LastEarthquake(
      dateTime: DateTime.parse(json['DateTime'] as String),
      latitude: latitude,
      longitude: longitude,
      magnitude: double.parse(json['Magnitude'] as String),
      depth: json['Kedalaman'] as String,
      region: json['Wilayah'] as String,
      potency: json['Potensi'] as String,
      regionFelt: json['Dirasakan'] as String,
      shakemap: json['Shakemap'] as String,
    );
  }

  final String potency;
  final String regionFelt;
  final String shakemap;
  Uri get shakemapUri {
    return baseShakemapUri.replace(
      pathSegments: [
        ...baseShakemapUri.pathSegments,
        shakemap,
      ],
    );
  }

  // https://data.bmkg.go.id/DataMKG/TEWS/[shakemap]
  static final Uri baseShakemapUri = Uri(
    scheme: 'https',
    host: 'data.bmkg.go.id',
    pathSegments: ['DataMKG', 'TEWS'],
  );
}

@immutable
final class RecentEarthquake extends Earthquake {
  const RecentEarthquake({
    required super.dateTime,
    required super.latitude,
    required super.longitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.potency,
  });

  factory RecentEarthquake.fromJson(Map<String, dynamic> json) {
    final (latitude, longitude) = _parseCoordinate(
      json['Coordinates'] as String,
    );

    return RecentEarthquake(
      dateTime: DateTime.parse(json['DateTime'] as String),
      latitude: latitude,
      longitude: longitude,
      magnitude: double.parse(json['Magnitude'] as String),
      depth: json['Kedalaman'] as String,
      region: json['Wilayah'] as String,
      potency: json['Potensi'] as String,
    );
  }

  final String potency;
}

@immutable
final class EarthquakeFelt extends Earthquake {
  const EarthquakeFelt({
    required super.dateTime,
    required super.latitude,
    required super.longitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.regionFelt,
  });

  factory EarthquakeFelt.fromJson(Map<String, dynamic> json) {
    final (latitude, longitude) = _parseCoordinate(
      json['Coordinates'] as String,
    );

    return EarthquakeFelt(
      dateTime: DateTime.parse(json['DateTime'] as String),
      latitude: latitude,
      longitude: longitude,
      magnitude: double.parse(json['Magnitude'] as String),
      depth: json['Kedalaman'] as String,
      region: json['Wilayah'] as String,
      regionFelt: json['Dirasakan'] as String,
    );
  }

  final String regionFelt;
}

(double latitude, double longitude) _parseCoordinate(String str) {
  final list = str.split(',');
  final latitude = double.parse(list[0]);
  final longitude = double.parse(list[1]);
  return (latitude, longitude);
}
