import 'package:codelandia_location_bloc/service/weather_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/weather_bloc.dart';
import 'package:intl/intl.dart';

import '../../service/define_location.dart';
import '../widgets/card_widget.dart';

var format = DateFormat('EEEEE, dd.MM.yyyy');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherBloc weatherBloc =
        WeatherBloc(weatherRepo: RepositoryProvider.of<WeatherRepo>(context));
    ScrollController gridViewController = ScrollController();
    return BlocProvider<WeatherBloc>(
      create: (context) => WeatherBloc(
        weatherRepo: RepositoryProvider.of<WeatherRepo>(context),
      )..add(
          WeatherInitialEvent(),
        ),
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case WeatherLoadingState:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              case WeatherLoadedState:
                final currentState = state as WeatherLoadedState;

                return RefreshIndicator(
                  onRefresh: () async {
                    await DefineLocation().location.getLocation();
                    weatherBloc.add(WeatherInitialEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${currentState.weatherModel.sys.country}, ${currentState.weatherModel.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Lat: ${currentState.weatherModel.coord.lat}\nLon: ${currentState.weatherModel.coord.lon}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currentState.weatherModel.main.temp.toString().substring(0, 2)}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    format.format(DateTime.now()),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                  'https://openweathermap.org/img/wn/${currentState.weatherModel.weather[0].icon}@2x.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                currentState.weatherModel.weather[0].description
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: GridView.count(
                                shrinkWrap: true,
                                controller: gridViewController,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                children: [
                                  CardWidget(
                                    currentState: currentState,
                                    title: 'Feels like',
                                    body:
                                        '${currentState.weatherModel.main.feelsLike.toString().substring(0, 2)}°C',
                                    icon: Icons.device_thermostat,
                                  ),
                                  CardWidget(
                                    currentState: currentState,
                                    title: 'Humidity',
                                    body:
                                        '${currentState.weatherModel.main.humidity.toString().substring(0, 2)}%',
                                    icon: Icons.water_drop_outlined,
                                  ),
                                  CardWidget(
                                    currentState: currentState,
                                    title: 'Visibility',
                                    body:
                                        '${currentState.weatherModel.visibility} m',
                                    icon: Icons.remove_red_eye,
                                  ),
                                  CardWidget(
                                    currentState: currentState,
                                    title: 'Wind speed',
                                    body:
                                        '${currentState.weatherModel.wind.speed} km/h',
                                    icon: Icons.air,
                                  ),
                                  CardWidget(
                                    currentState: currentState,
                                    title: 'Pressure',
                                    body:
                                        '${currentState.weatherModel.main.pressure} hPa',
                                    icon: Icons.compress,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              case WeatherErrorState:
                final currentState = state as WeatherErrorState;
                return Center(
                  child: Text(currentState.errorMessage),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
