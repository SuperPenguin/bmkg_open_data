import 'package:http/http.dart' as http;

abstract class BmkgHttpClient {
  const BmkgHttpClient();

  Future<http.Response> get(Uri url, {Map<String, String>? headers});
}

final class DefaultBmkgHttpClient extends BmkgHttpClient {
  const DefaultBmkgHttpClient() : super();

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return http.get(url, headers: headers);
  }
}
