class Location {
  const Location({
    required this.adm1,
    required this.adm2,
    required this.adm3,
    required this.adm4,
    required this.provinsi,
    required this.kotkab,
    required this.kecamatan,
    required this.desa,
    required this.lon,
    required this.lat,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      adm1: json['adm1'] as String,
      adm2: json['adm2'] as String,
      adm3: json['adm3'] as String,
      adm4: json['adm4'] as String,
      provinsi: json['provinsi'] as String,
      kotkab: json['kotkab'] as String,
      kecamatan: json['kecamatan'] as String,
      desa: json['desa'] as String,
      lon: (json['lon'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      timezone: json['timezone'] as String,
    );
  }

  final String adm1;
  final String adm2;
  final String adm3;
  final String adm4;
  final String provinsi;
  final String kotkab;
  final String kecamatan;
  final String desa;
  final double lon;
  final double lat;
  final String timezone;
}

class ForecastData {
  const ForecastData({
    required this.dateTime,
    required this.t,
    required this.tcc,
    required this.tp,
    required this.weather,
    required this.weatherDescription,
    required this.weatherDescriptionEn,
    required this.wdDeg,
    required this.wd,
    required this.wdTo,
    required this.ws,
    required this.hu,
    required this.vs,
    required this.vsText,
    required this.timeIndex,
    required this.analysisDateTime,
    required this.image,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      dateTime: DateTime.parse(json['datetime'] as String),
      t: (json['t'] as num).toDouble(),
      tcc: (json['tcc'] as num).toDouble(),
      tp: (json['tp'] as num).toDouble(),
      weather: (json['weather'] as num).toInt(),
      weatherDescription: json['weather_desc'] as String,
      weatherDescriptionEn: json['weather_desc_en'] as String,
      wdDeg: (json['wd_deg'] as num).toDouble(),
      wd: json['wd'] as String,
      wdTo: json['wd_to'] as String,
      ws: (json['ws'] as num).toDouble(),
      hu: (json['hu'] as num).toDouble(),
      vs: (json['vs'] as num).toDouble(),
      vsText: json['vs_text'] as String,
      timeIndex: json['time_index'] as String,
      analysisDateTime: DateTime.parse(json['analysis_date'] as String),
      image: json['image'] as String,
    );
  }

  final DateTime dateTime;
  final double t;
  final double tcc;
  final double tp;
  final int weather;
  final String weatherDescription;
  final String weatherDescriptionEn;
  final double wdDeg;
  final String wd;
  final String wdTo;
  final double ws;
  final double hu;
  final double vs;
  final String vsText;
  final String timeIndex;
  final DateTime analysisDateTime;
  final String image;
}

class WeatherForecast {
  const WeatherForecast({required this.location, required this.data});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>).first as Map<String, dynamic>;
    final weatherList = (data['cuaca'] as List<dynamic>).cast<List<dynamic>>();

    return WeatherForecast(
      location: Location.fromJson(json['lokasi'] as Map<String, dynamic>),
      data: weatherList
          .map((e) => e
              .map((i) => ForecastData.fromJson(i as Map<String, dynamic>))
              .toList())
          .toList(),
    );
  }

  final Location location;
  final List<List<ForecastData>> data;
}
