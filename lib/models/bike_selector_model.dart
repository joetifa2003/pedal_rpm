import 'package:flutter/material.dart';
import 'package:pedal_rpm/model/model.dart';

class BikeSelectorModel extends ChangeNotifier {
  List<Bike> _bikes = [];

  BikeSelectorModel(List<Bike> bikes) {
    setBikes(bikes);
  }

  List<Bike> get bikes => _bikes;

  void setBikes(List<Bike> value) {
    _bikes = value;
    notifyListeners();
  }

  void deleteBike(int index) async {
    await _bikes[index].delete();
    notifyListeners();
  }
}
