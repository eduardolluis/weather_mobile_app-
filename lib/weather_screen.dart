import 'dart:ui';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main card
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "300° F",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Icon(Icons.cloud, size: 64),
                          Text("Cloudy", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Weather Forecast",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20
            ),

            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Card(
                    child: Column(
                      children: [
                        Text("03:00"),
                        
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Placeholder(fallbackHeight: 150),

            const SizedBox(height: 20),

            // weather forecast
            const Placeholder(fallbackHeight: 150),

            const SizedBox(height: 20),

            // additional weather details
          ],
        ),
      ),
    );
  }
}
