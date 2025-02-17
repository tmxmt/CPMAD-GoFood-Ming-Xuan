///menu item from Firestore with optional ID, name, price, etc.
class MenuItem {
  String? id;
  String? name;
  double? price;
  String? description;
  String? category;

  MenuItem({this.id, this.name, this.price, this.description, this.category});

  /// create a MenuItem from a Firestore map 
  MenuItem.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    if (data['price'] != null) {
      price = (data['price'] as num).toDouble();
    }
    description = data['description'];
    category = data['category'];
  }

  /// Converts MenuItem into a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
    };
  }
}
