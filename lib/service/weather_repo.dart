import 'dart:developer';
import 'dart:io';

import 'package:codelandia_location_bloc/service/define_location.dart';

import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherRepo {
  String cityName = '';
  double? lon;
  double? lat;
  String lang = 'en';
  Future<WeatherModel?> fetchData() async {
    String url = '';
    if (cityName == '') {
      DefineLocation loc = DefineLocation();
      await loc.getLoc();
      lat = loc.lat;
      lon = loc.lon;
      if (lat != null && lon != null) {
        url =
            'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=d6252210c5c5d0de96584180e2e59732&lang=$lang';
      }
    } else {
      url =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=d6252210c5c5d0de96584180e2e59732&lang=$lang';
    }
    Response response = await Dio().get(url);

    try {
      if (response.statusCode == HttpStatus.ok) {
        var jsonData = response.data as Map<String, dynamic>;
        return WeatherModel.fromJson(jsonData);
      }
    } catch (e) {
      log(response.statusCode.toString());
      log('*****Print:$e');
      return null;
    }

    return null;
  }
}
