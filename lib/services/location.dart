import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:property_management/services/permission_handle.dart';

class Locate {

  PermissionService _permissionsService = PermissionService();

  //Get co-ordinates of device
  Future<Map> getCoordinates() async {
    Map<String, dynamic> coordinates;
    var status = await _permissionsService.requestPermission(PermissionGroup.location);
    if (status == true) {
      Location _locationService = Location();
      bool status = await _locationService.requestService();
      if (status) {
        await _locationService.changeSettings(
            accuracy: LocationAccuracy.HIGH, interval: 1000);
        //Get Location Data
        LocationData location;
        location = await _locationService.getLocation();
        var lat = location.latitude;
        print(lat);
        var long = location.longitude;
        print(long);
        coordinates = {"lat": lat, "long": long};
        return coordinates;
      }
    }
    else {
      //Executed if permission is not granted
      _permissionsService.requestPermission(PermissionGroup.location);
      return null;
    }
  }
}