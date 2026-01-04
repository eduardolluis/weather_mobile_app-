import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
            onPressed: () {
              print("Refresh weather data");
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // main card
          const Placeholder(fallbackHeight: 150),

          const SizedBox(height: 20),

          // weather forecast
          const Placeholder(fallbackHeight: 150),

          const SizedBox(height: 20),

          // additional weather details
          const Placeholder(fallbackHeight: 150),
        ],
      ),
    );
  }
}
