import 'package:codelandia_location_bloc/service/weather_repo.dart';
import 'package:codelandia_location_bloc/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => WeatherRepo(),
        child: const HomeScreen(),
      ),
    );
  }
}
