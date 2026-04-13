import 'dart:convert';
import 'package:http/http.dart' as http;

class AmadeusService {
  static const _proxyUrl = 'http://localhost:3000';

  Future<List<dynamic>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    int adults = 1,
  }) async {
    final uri = Uri.parse('$_proxyUrl/flights').replace(
      queryParameters: {
        'origin': origin,
        'destination': destination,
        'departureDate': departureDate,
        'adults': adults.toString(),
      },
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    } else {
      throw Exception('Flight search failed: ${res.body}');
    }
  }
}
