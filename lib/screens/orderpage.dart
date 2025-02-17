import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../model/order.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: FirestoreService().readOrderData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final mainTotal = order.mainPrice * order.mainQty;
              final sideTotal = order.sidePrice * order.sideQty;
              final drinkTotal = order.drinkPrice * order.drinkQty;

              // Build lines only if qty>0
              final lines = <String>[];
              if (order.mainQty > 0) {
                lines.add(
                  "Main: ${order.mainName} (x${order.mainQty}) => \$${mainTotal.toStringAsFixed(2)}",
                );
              }
              if (order.sideQty > 0) {
                lines.add(
                  "Side: ${order.sideName} (x${order.sideQty}) => \$${sideTotal.toStringAsFixed(2)}",
                );
              }
              if (order.drinkQty > 0) {
                lines.add(
                  "Drink: ${order.drinkName} (x${order.drinkQty}) => \$${drinkTotal.toStringAsFixed(2)}",
                );
              }
              lines.add("\nTotal: \$${order.totalAll.toStringAsFixed(2)}");

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${index + 1} - ${order.paymentMethod}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Placed on: ${order.dateTime}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(lines.join("\n")),
                      const SizedBox(height: 8),

                      // Show current status
                      Text(
                        "Status: ${order.status}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: (order.status == "in progress")
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // If "in progress", show "Received" button
                      if (order.status == "in progress")
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () async {
                              // Update to "completed"
                              await FirestoreService().updateOrderStatus(
                                order.docId,
                                "completed",
                              );
                            },
                            child: const Text("Received"),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
