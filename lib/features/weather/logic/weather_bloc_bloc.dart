import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/features/weather/data/weather_repository.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final WeatherRepository _weatherRepository = WeatherRepository();
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchLocation>(_onFetchLocation);
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());

      final result = await _weatherRepository.fetchWeather(event.position);
      result.fold(
        (failure) => emit(WeatherBlocFailure(failure.message)),
        (weather) => emit(WeatherBlocSuccess(weather)),
      );
    });
  }

  Future<void> _onFetchLocation(
    FetchLocation event,
    Emitter<WeatherBlocState> emit,
  ) async {
    emit(WeatherBlocLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(WeatherBlocFailure('Location services are disabled.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(WeatherBlocFailure('Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          WeatherBlocFailure('Location permissions are permanently denied.'),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      add(FetchWeather(position));
    } catch (e) {
      emit(WeatherBlocFailure('Failed to get location: $e'));
    }
  }
}
