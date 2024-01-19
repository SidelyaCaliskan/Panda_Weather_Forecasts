import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather/data/weather.dart';

class WeatherService {
  final String baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey =
      'ca6b909b393544f284383042241901'; // Replace with your actual API key

  Future<Weather> getCurrentWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current.json?key=$apiKey&q=$cityName'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
