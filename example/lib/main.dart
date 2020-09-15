import 'package:flutter/material.dart';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/battery_info.dart';
import 'package:battery_info/enums/charging_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Info plugin example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<BatteryInfo>(
                  future: BatteryInfoPlugin.batteryInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          'Battery Health: ${snapshot.data.health.toUpperCase()}');
                    }
                    return CircularProgressIndicator();
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<BatteryInfo>(
                  stream: BatteryInfoPlugin.batteryInfoStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text("Voltage: ${(snapshot.data.voltage)} mV"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Battery Level: ${(snapshot.data.batteryLevel)} %"),
                          SizedBox(
                            height: 20,
                          ),
                          _getChargeTime(snapshot.data),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _getChargeTime(BatteryInfo data) {
    if (data.chargingStatus == ChargingStatus.Charging) {
      return data.chargeTimeRemaining == -1
          ? Text("Calculating charge time remaining")
          : Text(
              "Charge time remaining: ${(data.chargeTimeRemaining / 1000 / 60).truncate()} minutes");
    }
    return Text("Battery is full or not connected to a power source");
  }
}
