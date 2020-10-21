import 'package:flutter/material.dart';
import 'package:pedal_rpm/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Manager extends ChangeNotifier {
  Bike _bike;
  List<Gear> _frontGears;
  List<Gear> _rearGears;
  int _curFrontGearNo = 1;
  int _curRearGearNo = 1;
  Gear _curFrontGear = Gear();
  Gear _curRearGear = Gear();
  double _speed = 0;
  double _maxSpeed = 0;
  SharedPreferences _sharedPreferences;

  Bike get bike => _bike;

  Future<void> setBike(Bike value) async {
    _bike = value;
    _frontGears =
        await _bike.getGears().orderBy("gear").type.equals("front").toList();
    _rearGears =
        await _bike.getGears().orderBy("gear").type.equals("rear").toList();

    _sharedPreferences = await SharedPreferences.getInstance();

    reset();
    notifyListeners();
  }

  List<Gear> get frontGears => _frontGears;

  List<Gear> get rearGears => _rearGears;

  int get curFrontGearNo => _curFrontGearNo;

  void setCurFrontGearNo(int value) {
    _curFrontGearNo = value;
    _curFrontGear = _frontGears[_curFrontGearNo - 1];

    _sharedPreferences.setInt("${bike.id}-oldFrontGearNo", _curFrontGearNo);
    notifyListeners();
  }

  void curFrontGearIncrement() {
    if (_curFrontGearNo >= 1 && _curFrontGearNo < _frontGears.length) {
      _curFrontGearNo++;
      _curFrontGear = _frontGears[_curFrontGearNo - 1];

      _sharedPreferences.setInt("${bike.id}-oldFrontGearNo", _curFrontGearNo);
      notifyListeners();
    }
  }

  void curFrontGearDecrement() {
    if (_curFrontGearNo > 1 && _curFrontGearNo <= _frontGears.length) {
      _curFrontGearNo--;
      _curFrontGear = _frontGears[_curFrontGearNo - 1];

      _sharedPreferences.setInt("${bike.id}-oldFrontGearNo", _curFrontGearNo);
      notifyListeners();
    }
  }

  int get curRearGearNo => _curRearGearNo;

  void setCurRearGearNo(int value) {
    _curRearGearNo = value;
    _curRearGear = _rearGears[_curRearGearNo - 1];

    _sharedPreferences.setInt("${bike.id}-oldRearGearNo", _curRearGearNo);
    notifyListeners();
  }

  void curRearGearIncrement() {
    if (_curRearGearNo >= 1 && _curRearGearNo < _rearGears.length) {
      _curRearGearNo++;
      _curRearGear = _rearGears[_curRearGearNo - 1];

      _sharedPreferences.setInt("${bike.id}-oldRearGearNo", _curRearGearNo);
      notifyListeners();
    }
  }

  void curRearGearDecrement() {
    if (_curRearGearNo > 1 && _curRearGearNo <= _rearGears.length) {
      _curRearGearNo--;
      _curRearGear = _rearGears[_curRearGearNo - 1];

      _sharedPreferences.setInt("${bike.id}-oldRearGearNo", _curRearGearNo);
      notifyListeners();
    }
  }

  Gear get curFrontGear => _curFrontGear;

  Gear get curRearGear => _curRearGear;

  double get speed => _speed;

  void setSpeed(double speed) {
    this._speed = speed;
    notifyListeners();
  }

  double get maxSpeed => _maxSpeed;

  void setMaxSpeed(double maxSpeed) {
    this._maxSpeed = maxSpeed;
    notifyListeners();
  }

  double get ratio {
    if (_bike != null) {
      return _curFrontGear.teath / _curRearGear.teath;
    } else {
      return 0;
    }
  }

  double get rpm {
    if (_bike != null) {
      double wheelRPS = _speed / (_bike.tire / 1000);
      return (wheelRPS / ratio) * 60;
    } else {
      return 0;
    }
  }

  void reset() {
    int oldFrontGear = _sharedPreferences.getInt("${bike.id}-oldFrontGearNo");
    int oldRearGear = _sharedPreferences.getInt("${bike.id}-oldRearGearNo");

    setSpeed(0);
    setMaxSpeed(0);

    oldFrontGear != null
        ? setCurFrontGearNo(oldFrontGear)
        : setCurFrontGearNo(_frontGears.length);

    oldRearGear != null
        ? setCurRearGearNo(oldRearGear)
        : setCurRearGearNo(_rearGears.length);
  }
}
