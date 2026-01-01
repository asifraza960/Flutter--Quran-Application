import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'listSeprater.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({Key? key}) : super(key: key);
  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  Location location = Location();
  LocationData? currentPosition;
  double? latitude, longitude;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Prayer Timing',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Constants.kPrimary
        ),
        body: FutureBuilder(
          future: getLoc(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Use actual location if available, else fallback
            final myCoordinates = latitude != null && longitude != null
                ? Coordinates(latitude!, longitude!)
                : Coordinates(33.7699333, 72.8248431);

            final params = CalculationMethodParameters.karachi();
            params.madhab = Madhab.hanafi;

            final prayerTime = PrayerTimes(
              date: DateTime.now(),
              coordinates: myCoordinates,
              calculationParameters: params,
            );
            //  exension method


            // Create a list of prayer names and times
            final prayers = {
              'Fajr': prayerTime.fajr,
              'Sunrise': prayerTime.sunrise,
              'Dhuhr': prayerTime.dhuhr,
              'Asr': prayerTime.asr,
              'Maghrib': prayerTime.maghrib,
              'Isha': prayerTime.isha,
            };

            return ListView.separated(
              padding: const EdgeInsets.all(12.0),
              itemCount: prayers.length,
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              itemBuilder: (context, index) {
                final prayerName = prayers.keys.elementAt(index);
                final prayerTimeValue = prayers[prayerName]!;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        prayerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        DateFormat.jm().format(toLocal(prayerTimeValue)),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),


                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    currentPosition = await location.getLocation();
    latitude = currentPosition!.latitude!;
    longitude = currentPosition!.longitude!;
  }
}
