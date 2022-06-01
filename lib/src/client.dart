import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

final Uri baseBmkgUri = Uri(
  scheme: 'https',
  host: 'data.bmkg.go.id',
);

http.Client Function() _createClient = () => http.Client();

@visibleForTesting
void overrideClient(http.Client Function() override) {
  _createClient = override;
}

Future<http.Response> clientGet(Uri url, {Map<String, String>? headers}) async {
  final client = _createClient();

  try {
    return await client.get(url, headers: headers);
  } finally {
    client.close();
  }
}
