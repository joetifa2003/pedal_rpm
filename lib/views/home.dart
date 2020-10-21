import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedal_rpm/models/manager.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' as local;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Manager model;

  void startSpeedStream() async {
    if (await isLocationServiceEnabled() == false) {
      await openLocationSettings();
    }

    getPositionStream(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 5,
    ).listen((event) {
      model.setSpeed(event.speed);
      if (model.speed > model.maxSpeed) {
        model.setMaxSpeed(model.speed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Manager>(context);
    startSpeedStream();

    return Scaffold(
      appBar: AppBar(
        title: Text("Pedal RPM"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              thickness: 3,
              color: Colors.grey[700],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "speed",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                          ),
                          Center(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                "${(model.speed * 3.6).toStringAsFixed(1)}",
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "speed_meter",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                          ),
                          Center(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                "${model.speed.toStringAsFixed(1)}",
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "rpm",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ).tr(),
                    ),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          "${model.rpm.toStringAsFixed(1)}",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey[700],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gearShifter(
                  model.curFrontGearIncrement,
                  model.curFrontGearDecrement,
                  model.curFrontGearNo,
                  "shifter_name_front",
                  model.curFrontGear.teath,
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "ratio",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                        ),
                        Center(
                          child: Text(
                            "${model.ratio.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                gearShifter(
                  model.curRearGearIncrement,
                  model.curRearGearDecrement,
                  model.curRearGearNo,
                  "shifter_name_rear",
                  model.curRearGear.teath,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget gearShifter(
    Function increment, Function decrement, int gear, String title, int teath) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title).tr(),
      CircleAvatar(
        backgroundColor: Colors.grey[800],
        radius: 30,
        child: IconButton(
          color: Colors.green,
          iconSize: 40,
          icon: Icon(Icons.add),
          onPressed: increment,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        gear.toString(),
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text("gear_teath").tr(args: [teath.toString()]),
      SizedBox(
        height: 10,
      ),
      CircleAvatar(
        backgroundColor: Colors.grey[800],
        radius: 30,
        child: IconButton(
          color: Colors.red,
          iconSize: 40,
          icon: Icon(Icons.remove),
          onPressed: decrement,
        ),
      ),
    ],
  );
}
