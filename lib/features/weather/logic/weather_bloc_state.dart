part of 'weather_bloc_bloc.dart';

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();
}

final class WeatherBlocInitial extends WeatherBlocState {
  const WeatherBlocInitial();

  @override
  List<Object> get props => [];
}

final class WeatherBlocLoading extends WeatherBlocState {
  const WeatherBlocLoading();

  @override
  List<Object> get props => [];
}

final class WeatherBlocFailure extends WeatherBlocState {
  final String message;

  const WeatherBlocFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class WeatherBlocSuccess extends WeatherBlocState {
  final Weather weather;

  const WeatherBlocSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}
