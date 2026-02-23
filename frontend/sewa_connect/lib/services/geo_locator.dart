import 'package:geolocator/geolocator.dart';

class GeoLocatorServices {

  Future<void> getCurrentLocation()async{
    try{
      LocationPermission permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
        permission = await Geolocator.requestPermission();
      }
      if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
        Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
        print(position);
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        print("Services enabled $serviceEnabled");
        print(position.altitude);
        print(position.latitude);
        print(position.longitude);
        print(position.speed);
      }
    }catch(e){
      print(e);
    }
  }


}