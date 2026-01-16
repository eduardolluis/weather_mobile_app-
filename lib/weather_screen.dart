import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_items.dart';
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "London";

    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,uk&units=metric&appid=$openWeatherAPIKEY',
      ),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw data['message'] ?? 'Failed to load weather data';
    }

    return data;
  }

  Future<Map<String, dynamic>> getForecastWeather() async {
    String cityName = "London";

    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&units=metric&appid=$openWeatherAPIKEY',
      ),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw data['message'] ?? 'Failed to load forecast data';
    }

    return data;
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
          ),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final double currentTemp = data['main']['temp'].toDouble();
          final String currentSky = data['weather'][0]['main'];
          final int currentPressure = data['main']['pressure'];
          final double currentWindSpeed = data['wind']['speed'];
          final int currentHumidity = data['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "${currentTemp.toStringAsFixed(1)} °C",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Icon(
                            currentSky == "Clouds" || currentSky == "Rain"
                                ? Icons.cloud
                                : Icons.wb_sunny,
                            size: 64,
                          ),
                          Text(
                            currentSky,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                FutureBuilder<Map<String, dynamic>>(
                  future: getForecastWeather(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    final List forecastList = snapshot.data!['list'];

                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          final hourlyForecast = forecastList[index + 1];
                          final time = DateTime.parse(hourlyForecast['dt_txt']);

                          return HourlyForecastItem(
                            time: DateFormat.Hm().format(time),
                            temperature:
                                "${hourlyForecast['main']['temp'].toStringAsFixed(0)} °C",
                            icon:
                                hourlyForecast['weather'][0]['main'] == "Clouds"
                                ? Icons.cloud
                                : Icons.wb_sunny,
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoWidget(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "$currentHumidity %",
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$currentWindSpeed m/s",
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.thermostat,
                      label: "Pressure",
                      value: "$currentPressure hPa",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
