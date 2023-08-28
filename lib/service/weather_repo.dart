import 'dart:io';

import 'package:codelandia_location_bloc/service/define_location.dart';

import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherRepo {
  double? lon;
  double? lat;
  Future<WeatherModel?> fetchData() async {
    DefineLocation loc = DefineLocation();
    await loc.getLoc();
    lat = loc.lat;
    lon = loc.lon;
    if (lat != null && lon != null) {
      String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=d6252210c5c5d0de96584180e2e59732';

      Response response = await Dio().get(url);

      try {
        if (response.statusCode == HttpStatus.ok) {
          var jsonData = response.data as Map<String, dynamic>;
          // print('*******${WeatherModel.fromJson(jsonData)}');
          return WeatherModel.fromJson(jsonData);
        }
      } catch (e) {
        print(response.statusCode);
        print('*****Print:${e}');
      }
    }
    return null;
  }
}
