import 'package:clima/reusable_widgets.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  /// This function tries to get the weatherData from weather.dart and pass it to the location_screen.
  Future<void> getLocationData() async {
    try {
      final dynamic weatherData = await WeatherModel().getCityWeather('Riyadh');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return LocationScreen(locationWeather: weatherData);
          },
        ),
      );
    } on NoInternetConnection {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        await snackBar(
          text: 'No network connection',
          duration: 86400,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () async {
              await getLocationData();
            },
          ),
        ),
      );
    } on DataIsNull {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        await snackBar(
          text: "Can't connect to server",
          duration: 86400,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () async {
              await getLocationData();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
