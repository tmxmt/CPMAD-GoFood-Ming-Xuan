import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/menuitem.dart';      
import '../model/order.dart';       

class FirestoreService {
  //  menu items Collection
  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menuItems');

  // Add a new menu item document
  Future<void> addItemData(
    String name,
    double price,
    String description,
    String category,
  ) async {
    var docRef = menuCollection.doc();
    debugPrint('add docRef: ${docRef.id}');
    await docRef.set({
      'id': docRef.id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
    });
  }

  // Read all menu items from Firestore
  Future<List<MenuItem>> readItemData() async {
    List<MenuItem> itemList = [];
    QuerySnapshot snapshot = await menuCollection.get();
    for (var document in snapshot.docs) {
      // Data read from DocumentSnapshot must be cast to Map<String, dynamic>
      MenuItem item = MenuItem.fromMap(document.data() as Map<String, dynamic>);
      itemList.add(item);
    }
    debugPrint('ItemList: $itemList');
    return itemList;
  }

  // Delete a specific menu item document by docId
  Future<void> deleteItemData(String docId) async {
    await menuCollection.doc(docId).delete();
    debugPrint('deleting id: $docId');
  }

  //  orders Collection
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  // Add a new order document
  Future<void> addOrderData(OrderModel order) async {
    final docRef = ordersCollection.doc(); // auto ID
    await docRef.set(order.toMap());
    debugPrint('Order added to Firestore: ${docRef.id}');
  }

  // Read all orders 
  Stream<List<OrderModel>> readOrderData() {
    return ordersCollection
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update the status of an existing order 
  Future<void> updateOrderStatus(String docId, String newStatus) async {
    await ordersCollection.doc(docId).update({'status': newStatus});
    debugPrint('Order $docId status updated to $newStatus');
  }
  //  feedback Collection
  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  // Add a new feedback document
  Future<void> addFeedback(String comment) async {
    final docRef = feedbackCollection.doc(); // auto ID
    await docRef.set({
      'comment': comment,
      'timestamp': DateTime.now().toIso8601String(),
    });
    debugPrint('Feedback added: ${docRef.id}');
  }
}
