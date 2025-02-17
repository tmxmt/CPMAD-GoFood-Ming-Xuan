import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'homepage.dart';
import 'profile.dart';
import 'about.dart';  
import '../model/order.dart';
import '../services/firestore_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Access the CartController via GetX
  final cartCtrl = Get.find<CartController>();

  String paymentMethod = "Cash on Delivery";
  int _selectedIndex = 1; // Cart index

  // Handle bottom nav bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      // Stay on Cart
    } else if (index == 2) {
      // AboutUs
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AboutPage()),
      );
    } else if (index == 3) {
      // Profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate item totals from the controller
    final mainTotal = cartCtrl.mainPrice.value * cartCtrl.mainQuantity.value;
    final sideTotal = cartCtrl.sidePrice.value * cartCtrl.sideQuantity.value;
    final drinkTotal = cartCtrl.drinkPrice.value * cartCtrl.drinkQuantity.value;
    final totalAll = mainTotal + sideTotal + drinkTotal;

    final totalQty = cartCtrl.mainQuantity.value +
        cartCtrl.sideQuantity.value +
        cartCtrl.drinkQuantity.value;

    return Scaffold(
      body: Column(
        children: [
          // Gradient banner
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (totalQty == 0)
                  ? const Center(
                      child: Text(
                        "Your cart is empty.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // If mainQty>0 => show row for main
                        if (cartCtrl.mainQuantity.value > 0)
                          _buildCartRow(
                            categoryLabel: "Main",
                            itemName: cartCtrl.mainName.value,
                            quantity: cartCtrl.mainQuantity.value,
                            itemPrice: cartCtrl.mainPrice.value,
                          ),

                        // If sideQty>0 => show row for side
                        if (cartCtrl.sideQuantity.value > 0)
                          _buildCartRow(
                            categoryLabel: "Side",
                            itemName: cartCtrl.sideName.value,
                            quantity: cartCtrl.sideQuantity.value,
                            itemPrice: cartCtrl.sidePrice.value,
                          ),

                        // If drinkQty>0 => show row for drink
                        if (cartCtrl.drinkQuantity.value > 0)
                          _buildCartRow(
                            categoryLabel: "Drink",
                            itemName: cartCtrl.drinkName.value,
                            quantity: cartCtrl.drinkQuantity.value,
                            itemPrice: cartCtrl.drinkPrice.value,
                          ),

                        const SizedBox(height: 16),
                        Text(
                          "Total Price: \$${totalAll.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Payment method
                        const Text(
                          "Payment Method:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        RadioListTile<String>(
                          title: const Text("Cash on Delivery"),
                          value: "Cash on Delivery",
                          groupValue: paymentMethod,
                          onChanged: (val) {
                            setState(() {
                              paymentMethod = val!;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Confirm Checkout
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                          ),
                          onPressed: () => _confirmCheckout(totalAll),
                          child: const Text(
                            "Confirm Checkout",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with 4 items
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "AboutUs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Build each category row
  Widget _buildCartRow({
    required String categoryLabel,
    required String itemName,
    required int quantity,
    required double itemPrice,
  }) {
    final itemTotal = itemPrice * quantity;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "$categoryLabel: $itemName (x$quantity)  \$${itemTotal.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _confirmCheckout(double totalAll) async {
    final totalQty = cartCtrl.mainQuantity.value +
        cartCtrl.sideQuantity.value +
        cartCtrl.drinkQuantity.value;

    if (totalQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items in cart!")),
      );
      return;
    }

    // Build summary lines
    final mainTotal = cartCtrl.mainPrice.value * cartCtrl.mainQuantity.value;
    final sideTotal = cartCtrl.sidePrice.value * cartCtrl.sideQuantity.value;
    final drinkTotal = cartCtrl.drinkPrice.value * cartCtrl.drinkQuantity.value;

    final lines = <String>[];
    if (cartCtrl.mainQuantity.value > 0) {
      lines.add(
        "Main: ${cartCtrl.mainName.value} "
        "(x${cartCtrl.mainQuantity.value})  \$${mainTotal.toStringAsFixed(2)}",
      );
    }
    if (cartCtrl.sideQuantity.value > 0) {
      lines.add(
        "Side: ${cartCtrl.sideName.value} "
        "(x${cartCtrl.sideQuantity.value})  \$${sideTotal.toStringAsFixed(2)}",
      );
    }
    if (cartCtrl.drinkQuantity.value > 0) {
      lines.add(
        "Drink: ${cartCtrl.drinkName.value} "
        "(x${cartCtrl.drinkQuantity.value})  \$${drinkTotal.toStringAsFixed(2)}",
      );
    }
    lines.add("\nTotal Price: \$${totalAll.toStringAsFixed(2)}");

    // Create order with default status = "in progress"
    final order = OrderModel(
      mainName: cartCtrl.mainName.value,
      mainQty: cartCtrl.mainQuantity.value,
      mainPrice: cartCtrl.mainPrice.value,
      sideName: cartCtrl.sideName.value,
      sideQty: cartCtrl.sideQuantity.value,
      sidePrice: cartCtrl.sidePrice.value,
      drinkName: cartCtrl.drinkName.value,
      drinkQty: cartCtrl.drinkQuantity.value,
      drinkPrice: cartCtrl.drinkPrice.value,
      paymentMethod: paymentMethod,
      totalAll: totalAll,
      dateTime: DateTime.now(),
      status: "in progress",
    );

    // Save to Firestore
    await FirestoreService().addOrderData(order);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Checkout"),
        content: Text(lines.join("\n")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
