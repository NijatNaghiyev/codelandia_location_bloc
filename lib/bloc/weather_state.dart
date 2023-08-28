part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final WeatherModel weatherModel;

  WeatherLoadedState({required this.weatherModel});
}

class WeatherErrorState extends WeatherState {
  final String errorMessage;

  WeatherErrorState({required this.errorMessage});
}
