import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double longitude;
  late double latitude;

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${apiKey}");

    NetworkHelper networkHelper = NetworkHelper(url);

    var weatherData = await networkHelper.fetchData();

    // print(weatherData);
    print({latitude, longitude, apiKey});

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationScreen(
                  locationWeather: weatherData,
                )));
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SpinKitChasingDots(
        color: Colors.white,
        size: 100.0,
      ),
    ));
  }
}
