import 'package:get/get.dart';

/// Manages selected food items and their quantities via GetX observables.
class CartController extends GetxController {
  // Radio selection IDs
  var selectedMainId = "".obs;
  var selectedSideId = "".obs;
  var selectedDrinkId = "".obs;

  // Quantities
  var mainQuantity = 0.obs;
  var sideQuantity = 0.obs;
  var drinkQuantity = 0.obs;

  // Names and prices
  var mainName = "No Main Selected".obs;
  var sideName = "No Side Selected".obs;
  var drinkName = "No Drink Selected".obs;
  var mainPrice = 0.0.obs;
  var sidePrice = 0.0.obs;
  var drinkPrice = 0.0.obs;

  /// Sets main dish info (ID, name, price).
  void setMain(String id, String name, double price) {
    selectedMainId.value = id;
    mainName.value = name;
    mainPrice.value = price;
  }

  /// Sets side dish info (ID, name, price).
  void setSide(String id, String name, double price) {
    selectedSideId.value = id;
    sideName.value = name;
    sidePrice.value = price;
  }

  /// Sets drink info (ID, name, price).
  void setDrink(String id, String name, double price) {
    selectedDrinkId.value = id;
    drinkName.value = name;
    drinkPrice.value = price;
  }
}
