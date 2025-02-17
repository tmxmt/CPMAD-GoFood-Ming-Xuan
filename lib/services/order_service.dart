class Order {
  final String mainName;
  final int mainQty;
  final double mainPrice;

  final String sideName;
  final int sideQty;
  final double sidePrice;

  final String drinkName;
  final int drinkQty;
  final double drinkPrice;

  final String paymentMethod;
  final double totalAll;

  final DateTime dateTime; // when the order was placed in real time

  Order({
    required this.mainName,
    required this.mainQty,
    required this.mainPrice,
    required this.sideName,
    required this.sideQty,
    required this.sidePrice,
    required this.drinkName,
    required this.drinkQty,
    required this.drinkPrice,
    required this.paymentMethod,
    required this.totalAll,
    required this.dateTime,
  });
}

class OrderService {
  static final List<Order> _orders = [];

  static List<Order> get orders => _orders;

  static void addOrder(Order order) {
    _orders.add(order);
  }
}
