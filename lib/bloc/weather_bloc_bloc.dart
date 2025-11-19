import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/repository/weather_repository.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final WeatherRepository _weatherRepository = WeatherRepository();
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());

      final result = await _weatherRepository.fetchWeather(event.position);
      result.fold(
        (failure) => emit(WeatherBlocFailure(failure.message)),
        (weather) => emit(WeatherBlocSuccess(weather)),
      );
    });
  }
}
