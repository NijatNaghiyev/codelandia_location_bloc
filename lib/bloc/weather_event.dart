part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherInitialEvent extends WeatherEvent {
  final String lang;
  final String cityName;
  WeatherInitialEvent({this.lang = 'en', this.cityName = ''});
}

class WeatherLoadingEvent extends WeatherEvent {}

class WeatherLoadedEvent extends WeatherEvent {}

class WeatherErrorEvent extends WeatherEvent {
  final String errorMessage;

  WeatherErrorEvent({required this.errorMessage});
}
