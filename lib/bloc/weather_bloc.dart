import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../service/weather_repo.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo weatherRepo;
  WeatherBloc({required this.weatherRepo}) : super(WeatherInitialState()) {
    on<WeatherInitialEvent>(weatherInitialEvent);
    on<WeatherLoadingEvent>(weatherLoadingEvent);
    on<WeatherErrorEvent>(weatherErrorEvent);
  }

  Future<FutureOr<void>> weatherInitialEvent(
      WeatherInitialEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadingState());
    var data = await weatherRepo.fetchData();
    if (data != null) {
      emit(WeatherLoadedState(weatherModel: data));
    } else {
      emit(WeatherErrorState(errorMessage: '*** Data not found***'));
    }
  }

  FutureOr<void> weatherLoadingEvent(
      WeatherLoadingEvent event, Emitter<WeatherState> emit) {
    emit(WeatherLoadingState());
  }

  FutureOr<void> weatherErrorEvent(
      WeatherErrorEvent event, Emitter<WeatherState> emit) {
    emit(WeatherErrorState(errorMessage: event.errorMessage));
  }
}
