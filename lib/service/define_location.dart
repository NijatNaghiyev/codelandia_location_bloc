import 'package:location/location.dart';

class DefineLocation {
  Location location = Location();

  double? lon;
  double? lat;

  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    lon = _locationData.longitude;
    lat = _locationData.latitude;

    print('Lon:$lon\nLat:$lat');
  }
}
