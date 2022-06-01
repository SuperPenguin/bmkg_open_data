import 'package:meta/meta.dart';

@immutable
abstract class Earthquake {
  const Earthquake({
    required this.dateTime,
    required this.longitude,
    required this.latitude,
    required this.magnitude,
    required this.depth,
    required this.region,
  });

  final DateTime dateTime;
  final double longitude;
  final double latitude;
  final double magnitude;
  final String depth;
  final String region;
}

@immutable
class LastEarthquake extends Earthquake {
  const LastEarthquake({
    required super.dateTime,
    required super.longitude,
    required super.latitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.potency,
    required this.regionFelt,
    required this.shakemap,
  });

  factory LastEarthquake.fromJson(Map<String, dynamic> json) {
    final coordinate = _LongLat.fromCoordinateString(
      json['Coordinates'] as String,
    );

    return LastEarthquake(
      dateTime: DateTime.parse(json['DateTime'] as String),
      longitude: coordinate.longitude,
      latitude: coordinate.latitude,
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
class RecentEarthquake extends Earthquake {
  const RecentEarthquake({
    required super.dateTime,
    required super.longitude,
    required super.latitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.potency,
  });

  factory RecentEarthquake.fromJson(Map<String, dynamic> json) {
    final coordinate = _LongLat.fromCoordinateString(
      json['Coordinates'] as String,
    );

    return RecentEarthquake(
      dateTime: DateTime.parse(json['DateTime'] as String),
      longitude: coordinate.longitude,
      latitude: coordinate.latitude,
      magnitude: double.parse(json['Magnitude'] as String),
      depth: json['Kedalaman'] as String,
      region: json['Wilayah'] as String,
      potency: json['Potensi'] as String,
    );
  }

  final String potency;
}

@immutable
class EarthquakeFelt extends Earthquake {
  const EarthquakeFelt({
    required super.dateTime,
    required super.longitude,
    required super.latitude,
    required super.magnitude,
    required super.depth,
    required super.region,
    required this.regionFelt,
  });

  factory EarthquakeFelt.fromJson(Map<String, dynamic> json) {
    final coordinate = _LongLat.fromCoordinateString(
      json['Coordinates'] as String,
    );

    return EarthquakeFelt(
      dateTime: DateTime.parse(json['DateTime'] as String),
      longitude: coordinate.longitude,
      latitude: coordinate.latitude,
      magnitude: double.parse(json['Magnitude'] as String),
      depth: json['Kedalaman'] as String,
      region: json['Wilayah'] as String,
      regionFelt: json['Dirasakan'] as String,
    );
  }

  final String regionFelt;
}

@immutable
class _LongLat {
  const _LongLat({
    required this.latitude,
    required this.longitude,
  });

  factory _LongLat.fromCoordinateString(String coordinate) {
    final list = coordinate.split(',');

    return _LongLat(
      latitude: double.parse(list[0]),
      longitude: double.parse(list[1]),
    );
  }

  final double latitude;
  final double longitude;
}
