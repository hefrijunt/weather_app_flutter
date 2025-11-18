import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/bloc/weather_bloc_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case > 200 && < 300:
        return Image.asset('assets/1.png');
      case > 300 && < 400:
        return Image.asset('assets/2.png');
      case > 500 && < 600:
        return Image.asset('assets/3.png');
      case > 600 && < 700:
        return Image.asset('assets/4.png');
      case > 700 && < 800:
        return Image.asset('assets/5.png');
      case 800:
        return Image.asset('assets/6.png');
      case > 800 && < 804:
        return Image.asset('assets/7.png');
      default:
        return Image.asset('assets/7.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),

      body: Stack(
        children: [
          /// BACKGROUND BLUR RADIUS COLORS
          Align(
            alignment: const AlignmentDirectional(3, -0.3),
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-3, -0.3),
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, -1.2),
            child: Container(
              width: 300,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
              ),
            ),
          ),

          /// Blur Layer, tidak menutupi UI
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
            child: Container(color: Colors.transparent),
          ),

          /// WEATHER CONTENT
          Padding(
            padding: EdgeInsets.fromLTRB(40, kToolbarHeight * 1.4, 40, 20),
            child: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
              builder: (context, state) {
                if (state is WeatherBlocSuccess) {
                  final weather = state.weather;

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      /// LOCATION
                      Text(
                        '📍 ${state.weather.areaName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// GREETING
                      Text(
                        getGreeting(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// WEATHER ICON
                      // Image.asset('assets/1.png', height: 140),
                      getWeatherIcon(state.weather.weatherConditionCode!),

                      /// TEMPERATURE
                      Center(
                        child: Text(
                          '${weather.temperature!.celsius!.round()}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      /// CONDITION
                      Center(
                        child: Text(
                          weather.weatherMain!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// DATE
                      Center(
                        child: Text(
                          DateFormat(
                            'EEEE dd -',
                          ).add_jm().format(state.weather.date!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Sunrise & Sunset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/11.png', scale: 8),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sunrise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    DateFormat().add_jm().format(
                                      state.weather.sunrise!,
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/12.png', scale: 8),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sunset',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    DateFormat().add_jm().format(
                                      state.weather.sunset!,
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const Divider(color: Colors.grey),

                      /// Temp Min & Max
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/13.png', scale: 8),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Temp Min',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "${state.weather.tempMin!.celsius!.round()} °C",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/14.png', scale: 8),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Temp Max',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "${state.weather.tempMax!.celsius!.round()} °C",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is WeatherBlocFailure) {
                  return const Center(
                    child: Text(
                      'Failed to fetch weather data. Please check your API key and internet connection.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// GREETING FUNCTION
String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 4 && hour < 12) {
    return "Good Morning";
  } else if (hour >= 12 && hour < 15) {
    return "Good Afternoon";
  } else if (hour >= 15 && hour < 18) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}
