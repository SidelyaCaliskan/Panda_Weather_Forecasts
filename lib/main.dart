import 'package:flutter/material.dart';
import 'package:weather_app/weather/data/weather.dart';
import 'package:weather_app/weather/service/weather_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      initialRoute: '/',
      routes: {
        '/': (context) => InputPage(),
        '/results': (context) {
          final cityName =
              ModalRoute.of(context)?.settings.arguments as String?;
          if (cityName == null || cityName.isEmpty) {
            // Handle the null or empty case, perhaps by returning to the previous page or showing an error
            return const Scaffold(
              body: Center(
                child: Text('No city name provided.'),
              ),
            );
          }
          return ResultsPage(cityName: cityName);
        },
      },
      // Removed the home property as it's not needed with initialRoute defined
    );
  }
}

class InputPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(controller: _controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String city = _controller.text;
          if (city.isNotEmpty) {
            Navigator.pushNamed(context, '/results', arguments: city);
          } else {
            // Handle the case where the text field is empty
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please enter a city name.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final String cityName;

  ResultsPage({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();

    return Scaffold(
      appBar: AppBar(title: Text('Weather Results')),
      body: FutureBuilder<Weather>(
        future: weatherService.getCurrentWeather(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No weather data available'));
          } else {
            final weather = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Location: ${weather.location.name}, ${weather.location.region}, ${weather.location.country}',
                      style: TextStyle(fontSize: 20)),
                  Text('Temperature: ${weather.current.tempC}°C',
                      style: TextStyle(fontSize: 20)),
                  // Add more details as needed
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
