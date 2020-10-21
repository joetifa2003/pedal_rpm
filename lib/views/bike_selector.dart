import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pedal_rpm/models/bike_selector_model.dart';
import 'package:pedal_rpm/models/manager.dart';
import 'package:pedal_rpm/views/add_bike.dart';
import 'package:pedal_rpm/views/home.dart';
import 'package:provider/provider.dart';

class BikeSelector extends StatefulWidget {
  @override
  _BikeSelectorState createState() => _BikeSelectorState();
}

class _BikeSelectorState extends State<BikeSelector> {
  BikeSelectorModel model;

  void openAddBike() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddBike(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    model = context.watch<BikeSelectorModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Pedal RPM"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        label: Text("اضافة دراجه"),
        icon: Icon(Icons.directions_bike),
        onPressed: openAddBike,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Conditional.single(
              context: context,
              conditionBuilder: (context) => model.bikes.length > 0,
              widgetBuilder: (context) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: 500,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Expanded(
                            flex: 5,
                            child: RaisedButton.icon(
                              icon: Icon(Icons.directions_bike),
                              label: Text(model.bikes[index].name),
                              onPressed: () async {
                                await context
                                    .read<Manager>()
                                    .setBike(model.bikes[index]);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              color: Colors.red,
                              iconSize: 35,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                model.deleteBike(index);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Divider();
                    },
                    itemCount: model.bikes.length,
                  ),
                );
              },
              fallbackBuilder: (context) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        "لا يوجد دراجات.",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.add),
                      color: Colors.amber,
                      textColor: Colors.white,
                      label: Text(
                        "أضافه دراجه الان",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: openAddBike,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
