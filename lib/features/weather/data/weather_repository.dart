import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/core/utils/either.dart';
import 'package:weather_app/core/utils/failure.dart';

class WeatherRepository {
  Future<Either<Failure, Weather>> fetchWeather(Position pos) async {
    try {
      WeatherFactory wf = WeatherFactory(
        "b737bd31c78313edeb7af5be630e6133",
        language: Language.ENGLISH,
      );

      Weather weather = await wf.currentWeatherByLocation(
        pos.latitude,
        pos.longitude,
      );
      return Right(weather);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
