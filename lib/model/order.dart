/// Represents a customer's order in Firestore, including items, totals, and status.
class OrderModel {
  final String docId;

  /// main dish
  final String mainName;
  final int mainQty;
  final double mainPrice;

  ///  side dish.
  final String sideName;
  final int sideQty;
  final double sidePrice;

  ///  drink.
  final String drinkName;
  final int drinkQty;
  final double drinkPrice;

  final String paymentMethod;

  /// Total price of the entire order.
  final double totalAll;

  /// Date and time when the order was placed.
  final DateTime dateTime;

  /// Current status of the order (in progress/completed)
  final String status;

  OrderModel({
    this.docId = "",
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
    required this.status,
  });

  /// Converts this order into a map so it can be stored in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'mainName': mainName,
      'mainQty': mainQty,
      'mainPrice': mainPrice,
      'sideName': sideName,
      'sideQty': sideQty,
      'sidePrice': sidePrice,
      'drinkName': drinkName,
      'drinkQty': drinkQty,
      'drinkPrice': drinkPrice,
      'paymentMethod': paymentMethod,
      'totalAll': totalAll,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
    };
  }

  /// Creates an OrderModel from Firestore data, using the given document ID.
  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      docId: docId,
      mainName: map['mainName'] ?? '',
      mainQty: map['mainQty'] ?? 0,
      mainPrice: (map['mainPrice'] ?? 0).toDouble(),
      sideName: map['sideName'] ?? '',
      sideQty: map['sideQty'] ?? 0,
      sidePrice: (map['sidePrice'] ?? 0).toDouble(),
      drinkName: map['drinkName'] ?? '',
      drinkQty: map['drinkQty'] ?? 0,
      drinkPrice: (map['drinkPrice'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      totalAll: (map['totalAll'] ?? 0).toDouble(),
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'in progress',
    );
  }
}
