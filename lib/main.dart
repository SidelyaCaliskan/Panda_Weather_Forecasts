import 'package:flutter/material.dart';
import 'package:weather_app/weather/service/weather_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => InputPage(),
      //   '/results': (context) => ResultsPage(),
      // },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Panda'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final weatherService = WeatherService();
            print("Weather request sent");
            final weather = await weatherService.getCurrentWeather('Izmir');
            print("Weather request completed");
            print("Weather in celcius: ${weather.current.tempC}");
          },
        ),
      ),
    );
  }
}

// class InputPage extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Enter Location')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: TextField(controller: _controller),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/results', arguments: _controller.text);
//         },
//         child: Icon(Icons.navigate_next),
//       ),
//     );
//   }
// }

// class ResultsPage extends StatelessWidget {
//   final String location;

//   ResultsPage({Key? key, required this.location}) : super(key: key);

//   Future<Map<String, dynamic>> fetchWeather(String location) async {
//     final apiKey = 'YOUR_API_KEY';
//     final response = await http.get(Uri.parse(
//         'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location'));

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load weather data');
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//   return Scaffold(appBar: AppBar(title: Text('Weather Results for $location')),
//  body:FutureBuilder<Map<String, dynamic>>(
//   future: fetchWeather(location),
// builder:(context, snapshot) {
//   if(snapshot.connectionState ==ConnectionState.waiting){
//     return const Center(child: CircularProgressIndicator(),);
// } else if (!snapshot.hasError) {
//   return Center(child: Text(''))
// }
// }
//   ]
// ],)
//   )
//   }
// }
