import 'package:get/get.dart';

class Message extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'Feels like': 'Feels like',
          'Humidity': 'Humidity',
          'Visibility': 'Visibility',
          'Wind speed': 'Wind speed',
          'Pressure': 'Pressure',
        },
        'az': {
          'Feels like': 'Hiss edilən',
          'Humidity': 'Nəm',
          'Visibility': 'Görünürlük',
          'Wind speed': 'Küləyin sürəti',
          'Pressure': 'Təzyiq',
        },
        'tr': {
          'Feels like': 'Hissedilen',
          'Humidity': 'Nem',
          'Visibility': 'Görüş',
          'Wind speed': 'Rüzgar hızı',
          'Pressure': 'Basınç',
        },
        'ja': {
          'Feels like': '体感',
          'Humidity': '湿度',
          'Visibility': '視界',
          'Wind speed': '風速',
          'Pressure': '気圧',
        },
        'ru': {
          'Feels like': 'Ощущается как',
          'Humidity': 'Влажность',
          'Visibility': 'Видимость',
          'Wind speed': 'Скорость ветра',
          'Pressure': 'Давление',
        },
      };
}
