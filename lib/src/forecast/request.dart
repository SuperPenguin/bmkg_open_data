import 'package:bmkg_open_data/src/client.dart';
import 'package:bmkg_open_data/src/forecast/model.dart';
import 'package:xml/xml.dart';

final Uri _baseUri = baseBmkgUri.replace(
  pathSegments: ['DataMKG', 'MEWS', 'DigitalForecast'],
);

Future<ForecastResponse> getForecast({
  ForecastPlace place = ForecastPlace.indonesia,
}) async {
  // https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/filename
  final requestUri = _baseUri.replace(
    pathSegments: [
      ..._baseUri.pathSegments,
      place.fileName,
    ],
  );

  final response = await clientGet(requestUri);
  final xmlDocument = XmlDocument.parse(response.body);
  return ForecastResponse.fromXmlDocument(xmlDocument);
}

enum ForecastPlace {
  aceh(
    label: 'Provinsi Aceh',
    fileName: 'DigitalForecast-Aceh.xml',
  ),
  bali(
    label: 'Provinsi Bali',
    fileName: 'DigitalForecast-Bali.xml',
  ),
  bangkaBelitung(
    label: 'Provinsi Bangka Belitung',
    fileName: 'DigitalForecast-BangkaBelitung.xml',
  ),
  banten(
    label: 'Provinsi Banten',
    fileName: 'DigitalForecast-Banten.xml',
  ),
  bengkulu(
    label: 'Provinsi Bengkulu',
    fileName: 'DigitalForecast-Bengkulu.xml',
  ),
  diYogyakarta(
    label: 'Provinsi DI Yogyakarta',
    fileName: 'DigitalForecast-DIYogyakarta.xml',
  ),
  dkiJakarta(
    label: 'Provinsi DKI Jakarta',
    fileName: 'DigitalForecast-DKIJakarta.xml',
  ),
  gorontalo(
    label: 'Provinsi Gorontalo',
    fileName: 'DigitalForecast-Gorontalo.xml',
  ),
  jambi(
    label: 'Provinsi Jambi',
    fileName: 'DigitalForecast-Jambi.xml',
  ),
  jawaBarat(
    label: 'Provinsi Jawa Barat',
    fileName: 'DigitalForecast-JawaBarat.xml',
  ),
  jawaTengah(
    label: 'Provinsi Jawa Tengah',
    fileName: 'DigitalForecast-JawaTengah.xml',
  ),
  jawaTimur(
    label: 'Provinsi Jawa Timur',
    fileName: 'DigitalForecast-JawaTimur.xml',
  ),
  kalimantanBarat(
    label: 'Provinsi Kalimantan Barat',
    fileName: 'DigitalForecast-KalimantanBarat.xml',
  ),
  kalimantanSelatan(
    label: 'Provinsi Kalimantan Selatan',
    fileName: 'DigitalForecast-KalimantanSelatan.xml',
  ),
  kalimantanTengah(
    label: 'Provinsi Kalimantan Tengah',
    fileName: 'DigitalForecast-KalimantanTengah.xml',
  ),
  kalimantanTimur(
    label: 'Provinsi Kalimantan Timur',
    fileName: 'DigitalForecast-KalimantanTimur.xml',
  ),
  kalimantanUtara(
    label: 'Provinsi Kalimantan Utara',
    fileName: 'DigitalForecast-KalimantanUtara.xml',
  ),
  kepulauanRiau(
    label: 'Provinsi Kepulauan Riau',
    fileName: 'DigitalForecast-KepulauanRiau.xml',
  ),
  lampung(
    label: 'Provinsi Lampung',
    fileName: 'DigitalForecast-Lampung.xml',
  ),
  maluku(
    label: 'Provinsi Maluku	',
    fileName: 'DigitalForecast-Maluku.xml',
  ),
  malukuUtara(
    label: 'Provinsi Maluku Utara',
    fileName: 'DigitalForecast-MalukuUtara.xml',
  ),
  nusaTenggaraBarat(
    label: 'Provinsi Nusa Tenggara Barat',
    fileName: 'DigitalForecast-NusaTenggaraBarat.xml',
  ),
  nusaTenggaraTimur(
    label: 'Provinsi Nusa Tenggara Timur',
    fileName: 'DigitalForecast-NusaTenggaraTimur.xml',
  ),
  papua(
    label: 'Provinsi Papua',
    fileName: 'DigitalForecast-Papua.xml',
  ),
  papuaBarat(
    label: 'Provinsi Papua Barat',
    fileName: 'DigitalForecast-PapuaBarat.xml',
  ),
  riau(
    label: 'Provinsi Riau',
    fileName: 'DigitalForecast-Riau.xml',
  ),
  sulawesiBarat(
    label: 'Provinsi Sulawesi Barat	',
    fileName: 'DigitalForecast-SulawesiBarat.xml',
  ),
  sulawesiSelatan(
    label: 'Provinsi Sulawesi Selatan',
    fileName: 'DigitalForecast-SulawesiSelatan.xml',
  ),
  sulawesiTengah(
    label: 'Provinsi Sulawesi Tengah',
    fileName: 'DigitalForecast-SulawesiTengah.xml',
  ),
  sulawesiTenggara(
    label: 'Provinsi Sulawesi Tenggara',
    fileName: 'DigitalForecast-SulawesiTenggara.xml',
  ),
  sulawesiUtara(
    label: 'Provinsi Sulawesi Utara',
    fileName: 'DigitalForecast-SulawesiUtara.xml',
  ),
  sumateraBarat(
    label: 'Provinsi Sumatera Barat',
    fileName: 'DigitalForecast-SumateraBarat.xml',
  ),
  sumateraSelatan(
    label: 'Provinsi Sumatera Selatan',
    fileName: 'DigitalForecast-SumateraSelatan.xml',
  ),
  sumateraUtara(
    label: 'Provinsi Sumatera Utara',
    fileName: 'DigitalForecast-SumateraUtara.xml',
  ),
  indonesia(
    label: 'Provinsi Indonesia',
    fileName: 'DigitalForecast-Indonesia.xml',
  );

  const ForecastPlace({
    required this.label,
    required this.fileName,
  });

  final String label;
  final String fileName;
}
