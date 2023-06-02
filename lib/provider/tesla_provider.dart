import 'package:flutter/material.dart';

class TeslaProvider extends ChangeNotifier {
  bool isRightDoorLock = true;
  bool isLeftDoorLock = true;
  bool isBonnetLock = true;
  bool isTrunkLock = true;

  void updateRightDoorLock() {
    isRightDoorLock = !isRightDoorLock;
    notifyListeners();
  }

  void updateLeftDoorLock() {
    isLeftDoorLock = !isLeftDoorLock;
    notifyListeners();
  }

  void updateBonnetDoorLock() {
    isBonnetLock = !isBonnetLock;
    notifyListeners();
  }

  void updateTrunkDoorLock() {
    isTrunkLock = !isTrunkLock;
    notifyListeners();
  }

  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isCool = true;
  bool isHot = false;

  void setCool() {
    isCool = true;
    isHot = false;
    temperature = 20;
    notifyListeners();
  }

  void setHot() {
    isCool = false;
    isHot = true;
    temperature = 26;
    notifyListeners();
  }

  int temperature = 18;

  void increaseTemperature() {
    temperature++;
    if (temperature > 25) {
      isCool = false;
      isHot = true;
    }
    notifyListeners();
  }

  void decreaseTemperature() {
    temperature--;
    if (temperature < 25) {
      isCool = true;
      isHot = false;
    }
    notifyListeners();
  }
}
