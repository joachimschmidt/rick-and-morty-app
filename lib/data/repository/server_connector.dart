import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/core/const.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';

class ServerConnector {
  static Future<String> getFromServer(String request) async {
    http.Client client = http.Client();
    final url = "https://$serverUrl/api/$request";
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ServerException();
    }
  }
}
