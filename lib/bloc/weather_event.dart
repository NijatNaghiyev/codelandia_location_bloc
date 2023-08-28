part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherInitialEvent extends WeatherEvent {}

class WeatherLoadingEvent extends WeatherEvent {}

class WeatherLoadedEvent extends WeatherEvent {}

class WeatherErrorEvent extends WeatherEvent {
  final String errorMessage;

  WeatherErrorEvent({required this.errorMessage});
}
