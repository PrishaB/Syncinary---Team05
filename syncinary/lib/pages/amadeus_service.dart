import 'dart:convert';
import 'package:http/http.dart' as http;

class AmadeusService {
  static const _baseUrl = 'https://test.api.amadeus.com';
  // Replace with your credentials from developers.amadeus.com
  static const _clientId = '<YOUR_API_KEY>';
  static const _clientSecret = '<YOUR_API_SECRET>';

  String? _accessToken;

  Future<void> _authenticate() async {
    final res = await http.post(
      Uri.parse('$_baseUrl/v1/security/oauth2/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );
    if (res.statusCode == 200) {
      _accessToken = jsonDecode(res.body)['access_token'];
    } else {
      throw Exception('Amadeus auth failed: ${res.body}');
    }
  }

  Future<List<dynamic>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    int adults = 1,
  }) async {
    await _authenticate();
    final uri = Uri.parse('$_baseUrl/v2/shopping/flight-offers').replace(
      queryParameters: {
        'originLocationCode': origin,
        'destinationLocationCode': destination,
        'departureDate': departureDate,
        'adults': adults.toString(),
        'max': '10',
      },
    );
    final res = await http.get(uri, headers: {'Authorization': 'Bearer $_accessToken'});
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Flight search failed: ${res.body}');
    }
  }
}
