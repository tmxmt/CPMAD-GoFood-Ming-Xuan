class CartService {
  //  order info for main
  static String mainName = "No Main Selected";
  static int mainQty = 0;
  static double mainPrice = 0.0;

  //  order info for side
  static String sideName = "No Side Selected";
  static int sideQty = 0;
  static double sidePrice = 0.0;

  //  order info for drink
  static String drinkName = "No Drink Selected";
  static int drinkQty = 0;
  static double drinkPrice = 0.0;

  // Save order from MenuPage
  static void setOrder({
    required String main,
    required int mainQuantity,
    required double mainP,
    required String side,
    required int sideQuantity,
    required double sideP,
    required String drink,
    required int drinkQuantity,
    required double drinkP,
  }) {
    mainName = main;
    mainQty = mainQuantity;
    mainPrice = mainP;

    sideName = side;
    sideQty = sideQuantity;
    sidePrice = sideP;

    drinkName = drink;
    drinkQty = drinkQuantity;
    drinkPrice = drinkP;
  }
}
