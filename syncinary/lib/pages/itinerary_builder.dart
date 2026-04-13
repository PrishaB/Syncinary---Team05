import 'package:flutter/material.dart';
import 'amadeus_service.dart';
import 'flight_search.dart';

class itinerary_builder extends StatefulWidget {
  const itinerary_builder({super.key});

  @override
  State<itinerary_builder> createState() => _itineraryState();

}

class _itineraryState extends State<itinerary_builder> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final _amadeus = AmadeusService();

  int currentDisplay = 0;
  DateTime? _departureDate;
  bool _loading = false; 

  

  void updateDisplay(int display) {
    setState(() {
      currentDisplay = display;
    });
  }

  @override
  
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            ColoredBox(
              color: Color(0xFFE8DEF8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  const Icon(Icons.menu),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Where are you starting from?',
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => updateDisplay(1),
              child: const Text('Next'),
            ),
          ],
        ),
      ),

      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            ColoredBox(
              color: Color(0xFFE8DEF8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  const Icon(Icons.menu),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Choose destination',
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => updateDisplay(2),
              child: const Text('Next'),
            ),
          ],
        ),
      ),

      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(_departureDate == null
                ? 'No departure date selected'
                : 'Departure: ${_departureDate!.toLocal().toString().split(' ')[0]}'),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _departureDate = picked);
              },
              child: const Text('Pick Departure Date'),
            ),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                if (_startController.text.isEmpty ||
                    _endController.text.isEmpty ||
                    _departureDate == null) return;
                setState(() => _loading = true);
                try {
                  final date = _departureDate!.toLocal().toString().split(' ')[0];
                  final results = await _amadeus.searchFlights(
                    origin: _startController.text.trim().toUpperCase(),
                    destination: _endController.text.trim().toUpperCase(),
                    departureDate: date,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => flight_search(
                          title: 'Flight Results',
                          initialResults: results,
                        ),
                      ),
                    );
                  }
                } finally {
                  setState(() => _loading = false);
                }
              },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search Flights'),
            ),
          ],
        ),
      )
      
    ];

    return Scaffold(
      appBar: AppBar(
        // title: Text("Schedule Builder"),
        centerTitle: true,
        
        backgroundColor: Color(0xFFE8DEF8),
        title: 
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                  onPressed: () => updateDisplay(0), 
                  icon: const Icon(Icons.star_border_outlined),
                  color: currentDisplay == 0 ? Color(0xFFF3EDF7) : Color(0xFF49454F),
                  ),

                  Text("From"),
                ]
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                  onPressed: () => updateDisplay(1), 
                  icon: const Icon(Icons.star_border_outlined),
                  color: currentDisplay == 1 ? Color(0xFFF3EDF7) : Color(0xFF49454F),
                  ),

                  Text("Destination"),
                ]
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                  onPressed: () => updateDisplay(2), 
                  icon: const Icon(Icons.star_border_outlined),
                  color: currentDisplay == 2 ? Color(0xFFF3EDF7) : Color(0xFF49454F),
                  ),

                  Text("Dates"),
                ]
              ),
            ]
          )
      ),

      body: screens[currentDisplay],

    );
  }
}
