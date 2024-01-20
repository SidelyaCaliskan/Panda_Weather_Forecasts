import 'package:flutter/material.dart';
import 'package:weather_app/weather/data/weather.dart';
import 'package:weather_app/weather/service/AirQualityService.dart';
import 'package:weather_app/weather/service/weather_service.dart';

import 'weather/data/airQuality.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors
            .pinkAccent, // This is the color used as the primary swatch in Material 3.
      ),
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
    final airQualityService = AirQualityService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Results'),
        backgroundColor: Colors.purple, // Custom AppBar color
      ),
      body: FutureBuilder<Weather>(
        future: weatherService.getCurrentWeather(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No weather data available'));
          } else {
            // When we have weather data, proceed to build the UI for air quality.
            final weather = snapshot.data!;
            return FutureBuilder<AirQuality>(
              future: airQualityService.getCurrentAirQuality(cityName),
              builder: (context, airQualitySnapshot) {
                if (airQualitySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (airQualitySnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${airQualitySnapshot.error}'));
                } else if (!airQualitySnapshot.hasData) {
                  return const Center(
                      child: Text('No air quality data available'));
                } else {
                  // When we have both weather and air quality data, build the UI for both.
                  final airQuality = airQualitySnapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(
                              Icons.thermostat_outlined,
                              color: Colors.pinkAccent,
                              size: 24.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Temperature: ${weather.current.tempC}°C',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Add some spacing
                        Text(
                          'Air Quality Index (US EPA): ${airQuality.usEpaIndex}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          'PM2.5: ${airQuality.pm25} µg/m³',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                          ),
                        ),
                        // ... additional details ...
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
