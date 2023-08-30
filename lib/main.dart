import 'dart:developer';

import 'package:codelandia_location_bloc/service/weather_repo.dart';
import 'package:codelandia_location_bloc/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'localization/message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Message(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
