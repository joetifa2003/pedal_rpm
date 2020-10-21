import 'package:flutter/material.dart';
import 'package:pedal_rpm/model/model.dart';
import 'package:pedal_rpm/models/bike_selector_model.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AddBike extends StatefulWidget {
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  TextEditingController txtBikeName = TextEditingController();
  TextEditingController txtTire = TextEditingController();
  TextEditingController txtFrontGears = TextEditingController();
  TextEditingController txtRearGears = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("add_bike_title").tr(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: txtBikeName,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: "اسم الدراجه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: txtTire,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "محيط العجله",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: txtFrontGears,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "التروس الأماميه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: txtRearGears,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "التروس الخلفيه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("add_bike_btn").tr(),
                    onPressed: () async {
                      int bikeID = await Bike(
                        name: txtBikeName.text,
                        tire: double.parse(txtTire.text),
                      ).save();

                      List<String> frontGearsSplited =
                          txtFrontGears.text.split("-");
                      List<String> rearGearsSplited =
                          txtRearGears.text.split("-");

                      List<Gear> frontGears = [];
                      List<Gear> rearGears = [];

                      for (var i = 0; i < frontGearsSplited.length; i++) {
                        frontGears.add(
                          Gear(
                            bike_id: bikeID,
                            gear: frontGearsSplited.length - i,
                            teath: int.parse(frontGearsSplited[i]),
                            type: "front",
                          ),
                        );
                      }

                      for (var i = 0; i < rearGearsSplited.length; i++) {
                        rearGears.add(
                          Gear(
                            bike_id: bikeID,
                            gear: rearGearsSplited.length - i,
                            teath: int.parse(rearGearsSplited[i]),
                            type: "rear",
                          ),
                        );
                      }

                      await Gear.saveAll(frontGears + rearGears);

                      context
                          .read<BikeSelectorModel>()
                          .setBikes(await Bike().select().toList());

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
