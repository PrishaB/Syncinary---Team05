import 'package:flutter/material.dart';

class itinerary_builder extends StatefulWidget {
  const itinerary_builder({super.key});

  @override
  State<itinerary_builder> createState() => _itineraryState();

}

class _itineraryState extends State<itinerary_builder> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  
  int currentDisplay = 0; 

  

  void updateDisplay(int display) {
    setState(() {
      currentDisplay = display;
    });
  }

  @override
  
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Center(
        child: 
        ColoredBox(
          color: Color(0xFFE8DEF8),
           
          child:
            Row(
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
      ),

      Center(
        child: 
        ColoredBox(
          color: Color(0xFFE8DEF8),
           
          child:
            Row(
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
      ),

      Center(child: Text("Test"),)
      
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
