part of 'weather_bloc_bloc.dart';

sealed class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];

  get position => null;
}

final class FetchWeather extends WeatherBlocEvent {
  // ignore: annotate_overrides
  final Position position;

  const FetchWeather(this.position);

  @override
  List<Object> get props => [position];
}
