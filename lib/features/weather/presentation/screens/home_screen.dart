import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/features/weather/logic/weather_bloc_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/sun_image.dart';
import 'package:weather_app/features/weather/presentation/widgets/temp_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _getWeatherIcon(int? code) {
    if (code == null) {
      return Image.asset('assets/7.png');
    }
    if (code >= 200 && code < 300) {
      return Image.asset('assets/1.png');
    } else if (code >= 300 && code < 400) {
      return Image.asset('assets/2.png');
    } else if (code >= 500 && code < 600) {
      return Image.asset('assets/8.png');
    } else if (code >= 600 && code < 700) {
      return Image.asset('assets/3.png');
    } else if (code >= 700 && code < 800) {
      return Image.asset('assets/5.png');
    } else if (code == 800) {
      return Image.asset('assets/6.png');
    } else {
      return Image.asset('assets/7.png');
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<WeatherBlocBloc>().add(const FetchLocation());
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
          // Background Blur Colors
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
            child: Container(color: Colors.transparent),
          ),

          /// WEATHER CONTENT
          Padding(
            padding: EdgeInsets.fromLTRB(40, kToolbarHeight * 1.4, 40, 20),
            // Menggunakan BLoC dan State yang sudah direfaktor
            child: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
              builder: (context, state) {
                // Menggunakan switch expression untuk menangani semua state
                return switch (state) {
                  // KASUS LOADING
                  WeatherBlocLoading() => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                  // KASUS FAILURE
                  WeatherBlocFailure(message: final errorMessage) => Center(
                    child: Text(
                      'Error: $errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  // KASUS INITIAL
                  WeatherBlocInitial() => const Center(
                    child: Text(
                      'Tekan tombol untuk memuat cuaca.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  // KASUS SUCCESS
                  WeatherBlocSuccess(weather: final weatherData) => ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      /// LOCATION
                      Text(
                        '📍 ${weatherData.areaName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// GREETING
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// WEATHER ICON
                      _getWeatherIcon(weatherData.weatherConditionCode),

                      /// TEMPERATURE
                      Center(
                        child: Text(
                          '${weatherData.temperature!.celsius!.round()}°C',
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
                          weatherData.weatherMain!.toUpperCase(),
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
                          ).add_jm().format(weatherData.date!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Sunrise & Sunset
                      const SunImageWidget(),

                      const SizedBox(height: 5),
                      const Divider(color: Colors.grey),

                      /// Temp Min & Max
                      const TempImage(),
                    ],
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
