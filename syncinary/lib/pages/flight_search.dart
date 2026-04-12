import 'package:flutter/material.dart';
import 'amadeus_service.dart';

class flight_search extends StatefulWidget {
  const flight_search({super.key, required this.title});
  final String title;

  @override
  State<flight_search> createState() => _FlightSearchState();
}

class _FlightSearchState extends State<flight_search> {
  final _amadeus = AmadeusService();
  final _originCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  List<dynamic> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _search() async {
    setState(() { _loading = true; _error = null; });
    try {
      final flights = await _amadeus.searchFlights(
        origin: _originCtrl.text.trim().toUpperCase(),
        destination: _destCtrl.text.trim().toUpperCase(),
        departureDate: _dateCtrl.text.trim(),
      );
      setState(() { _results = flights; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  String _flightSummary(dynamic offer) {
    final seg = offer['itineraries'][0]['segments'][0];
    final dep = seg['departure']['iataCode'];
    final arr = seg['arrival']['iataCode'];
    final time = seg['departure']['at'];
    final price = offer['price']['total'];
    return '$dep → $arr  |  $time  |  \$$price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _originCtrl, decoration: const InputDecoration(labelText: 'Origin (e.g. JFK)')),
            TextField(controller: _destCtrl, decoration: const InputDecoration(labelText: 'Destination (e.g. LAX)')),
            TextField(controller: _dateCtrl, decoration: const InputDecoration(labelText: 'Departure Date (YYYY-MM-DD)')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _search, child: const Text('Search Flights')),
            const SizedBox(height: 12),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, i) => Card(
                  child: ListTile(title: Text(_flightSummary(_results[i]))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
