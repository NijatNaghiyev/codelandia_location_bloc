import 'package:codelandia_location_bloc/constant/languages.dart';
import 'package:codelandia_location_bloc/service/weather_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/weather_bloc.dart';
import 'package:intl/intl.dart';

import '../widgets/card_widget.dart';

var format = DateFormat('EEEE, dd.MM.yyyy');
String language = 'en';
String dropDownValue = 'en';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();

  WeatherBloc weatherBloc = WeatherBloc(
    weatherRepo: WeatherRepo(),
  );

  @override
  void initState() {
    super.initState();
    weatherBloc.add(WeatherInitialEvent(lang: language));
  }

  @override
  Widget build(BuildContext context) {
    ScrollController gridViewController = ScrollController();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        bloc: weatherBloc,
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
                  weatherBloc.add(WeatherInitialEvent(lang: language));
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: Colors.grey,
                                value: dropDownValue,
                                items: languages.entries
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.key,
                                        child: Text(
                                          e.value.toUpperCase(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  dropDownValue = value!;
                                  language = value;
                                  Get.updateLocale(Locale(value));
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onSubmitted: (value) {
                                      textEditingController.clear();

                                      weatherBloc.add(
                                        WeatherInitialEvent(
                                          cityName: value.trim(),
                                          lang: language,
                                        ),
                                      );
                                    },
                                    controller: textEditingController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Search city',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              IconButton(
                                  onPressed: () {
                                    textEditingController.clear();
                                    weatherBloc.add(
                                        WeatherInitialEvent(lang: language));
                                  },
                                  icon: const Icon(
                                    Icons.location_on_sharp,
                                    color: Colors.white,
                                  )),
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
                                '${(currentState.weatherModel.main.temp - 273).round()}°C',
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
                                  title: 'Feels like'.tr,
                                  body:
                                      '${(currentState.weatherModel.main.feelsLike - 273).round()}°C',
                                  icon: Icons.device_thermostat,
                                ),
                                CardWidget(
                                  currentState: currentState,
                                  title: 'Humidity'.tr,
                                  body:
                                      '${currentState.weatherModel.main.humidity.toString().substring(0, 2)}%',
                                  icon: Icons.water_drop_outlined,
                                ),
                                CardWidget(
                                  currentState: currentState,
                                  title: 'Visibility'.tr,
                                  body:
                                      '${currentState.weatherModel.visibility} m',
                                  icon: Icons.remove_red_eye,
                                ),
                                CardWidget(
                                  currentState: currentState,
                                  title: 'Wind speed'.tr,
                                  body:
                                      '${currentState.weatherModel.wind.speed} km/h',
                                  icon: Icons.air,
                                ),
                                CardWidget(
                                  currentState: currentState,
                                  title: 'Pressure'.tr,
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
                child: Text(
                  currentState.errorMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
      // ),
    );
  }
}
