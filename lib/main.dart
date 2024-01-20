import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      appBar: AppBar(title: const Text('Panda Weather')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter City Name', // Placeholder text
                  border: OutlineInputBorder(
                    // Normal border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // Border when TextField is enabled
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border when TextField is focused
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon:
                      Icon(Icons.cloud, color: Colors.purple), // Cloud icon
                ),
              ),
            ],
          ),
        ),
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
        child: SvgPicture.asset(
          'assets/panda.svg',
          // You can set the color if you want
          width: 24.0, // Set a suitable size for the icon
          height: 24.0,
        ),
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
            final weather = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        // Display temperature icon
                        Icon(
                          Icons.thermostat_outlined,
                          color: Colors.pinkAccent, // Icon color
                          size: 24.0,
                        ),
                        const SizedBox(
                            width: 10), // Spacing between icon and text
                        // Temperature text
                        Text(
                          'Temperature: ${weather.current.tempC}°C',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.purple, // Text color
                          ),
                        ),
                      ],
                    ),
                    // Additional details...
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
