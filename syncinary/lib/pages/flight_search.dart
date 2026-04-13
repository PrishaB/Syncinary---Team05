import 'package:flutter/material.dart';

class flight_search extends StatelessWidget {
  const flight_search({super.key, required this.title, required this.initialResults});

  final String title;
  final List<dynamic> initialResults;

  String _flightSummary(dynamic offer) {
    final flights = offer['flights'] as List<dynamic>;
    final first = flights.first;
    final dep = first['departure_airport']['id'];
    final arr = flights.last['arrival_airport']['id'];
    final time = first['departure_airport']['time'];
    final price = offer['price'];
    return '$dep → $arr  |  $time  |  \$$price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8DEF8),
        title: Text(title),
      ),
      body: initialResults.isEmpty
          ? const Center(child: Text('No flights found.'))
          : ListView.builder(
              itemCount: initialResults.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(title: Text(_flightSummary(initialResults[i]))),
              ),
            ),
    );
  }
}
