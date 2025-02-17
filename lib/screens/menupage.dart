import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';  
import '../services/firestore_service.dart';
import '../model/menuitem.dart';
import 'cartpage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Access the CartController via GetX
  final cartCtrl = Get.find<CartController>();

  // Declare the bottom nav index
  int _selectedIndex = 0;

  // List of items fetched from Firestore
  List<MenuItem> allItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final items = await FirestoreService().readItemData();
    setState(() {
      allItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Separate items by category
    final mains = allItems.where((item) => item.category == "Main").toList();
    final sides = allItems.where((item) => item.category == "Side").toList();
    final drinks = allItems.where((item) => item.category == "Drink").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Colors.green,
      ),
      body: allItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Mains Section
                    const Text(
                      "Mains",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ..._buildRadioList(
                      items: mains,
                      groupValue: cartCtrl.selectedMainId.value,
                      onChanged: (value) {
                        setState(() {
                          // Update selectedMainId in the controller
                          cartCtrl.selectedMainId.value = value ?? "";

                          // Also set mainName and mainPrice
                          final chosen = mains.firstWhere(
                            (m) => m.id == value,
                            orElse: () => MenuItem(
                              id: "none",
                              name: "No Main",
                              price: 0.0,
                            ),
                          );
                          cartCtrl.mainName.value = chosen.name ?? "No Main";
                          cartCtrl.mainPrice.value = chosen.price ?? 0.0;
                        });
                      },
                    ),
                    // Mains Quantity
                    Row(
                      children: [
                        const Text("Quantity: "),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartCtrl.mainQuantity.value > 0) {
                              cartCtrl.mainQuantity.value--;
                              setState(() {});
                            }
                          },
                        ),
                        // Use Obx to watch the quantity
                        Obx(() => Text("${cartCtrl.mainQuantity.value}")),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartCtrl.mainQuantity.value++;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sides Section
                    const Text(
                      "Sides",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ..._buildRadioList(
                      items: sides,
                      groupValue: cartCtrl.selectedSideId.value,
                      onChanged: (value) {
                        setState(() {
                          cartCtrl.selectedSideId.value = value ?? "";
                          final chosen = sides.firstWhere(
                            (s) => s.id == value,
                            orElse: () => MenuItem(
                              id: "none",
                              name: "No Side",
                              price: 0.0,
                            ),
                          );
                          cartCtrl.sideName.value = chosen.name ?? "No Side";
                          cartCtrl.sidePrice.value = chosen.price ?? 0.0;
                        });
                      },
                    ),
                    // Sides Quantity
                    Row(
                      children: [
                        const Text("Quantity: "),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartCtrl.sideQuantity.value > 0) {
                              cartCtrl.sideQuantity.value--;
                              setState(() {});
                            }
                          },
                        ),
                        Obx(() => Text("${cartCtrl.sideQuantity.value}")),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartCtrl.sideQuantity.value++;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Drinks Section
                    const Text(
                      "Drinks",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ..._buildRadioList(
                      items: drinks,
                      groupValue: cartCtrl.selectedDrinkId.value,
                      onChanged: (value) {
                        setState(() {
                          cartCtrl.selectedDrinkId.value = value ?? "";
                          final chosen = drinks.firstWhere(
                            (d) => d.id == value,
                            orElse: () => MenuItem(
                              id: "none",
                              name: "No Drink",
                              price: 0.0,
                            ),
                          );
                          cartCtrl.drinkName.value = chosen.name ?? "No Drink";
                          cartCtrl.drinkPrice.value = chosen.price ?? 0.0;
                        });
                      },
                    ),
                    // Drinks Quantity
                    Row(
                      children: [
                        const Text("Quantity: "),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartCtrl.drinkQuantity.value > 0) {
                              cartCtrl.drinkQuantity.value--;
                              setState(() {});
                            }
                          },
                        ),
                        Obx(() => Text("${cartCtrl.drinkQuantity.value}")),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartCtrl.drinkQuantity.value++;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Confirm Order Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                      ),
                      onPressed: _onConfirmOrder,
                      child: const Text(
                        "Confirm Order",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }

 // build radio list
  List<Widget> _buildRadioList({
    required List<MenuItem> items,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return items.map((item) {
      final price = item.price?.toStringAsFixed(2) ?? "0.00";
      return RadioListTile<String>(
        title: Text("${item.name} (\$$price)"),
        subtitle: Text(item.description ?? "No description"),
        value: item.id!,
        groupValue: groupValue,
        onChanged: onChanged,
      );
    }).toList();
  }

  // Confirm order (summary box)
  void _onConfirmOrder() {
    final totalQty = cartCtrl.mainQuantity.value +
        cartCtrl.sideQuantity.value +
        cartCtrl.drinkQuantity.value;

    if (totalQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items selected. Please choose at least 1.")),
      );
      return;
    }

    final mainTotal = cartCtrl.mainPrice.value * cartCtrl.mainQuantity.value;
    final sideTotal = cartCtrl.sidePrice.value * cartCtrl.sideQuantity.value;
    final drinkTotal = cartCtrl.drinkPrice.value * cartCtrl.drinkQuantity.value;
    final totalAll = mainTotal + sideTotal + drinkTotal;

    final summaryLines = <String>[];
    if (cartCtrl.mainQuantity.value > 0) {
      summaryLines.add(
        "Main: ${cartCtrl.mainName.value} "
        "(x${cartCtrl.mainQuantity.value})  \$${mainTotal.toStringAsFixed(2)}",
      );
    }
    if (cartCtrl.sideQuantity.value > 0) {
      summaryLines.add(
        "Side: ${cartCtrl.sideName.value} "
        "(x${cartCtrl.sideQuantity.value})  \$${sideTotal.toStringAsFixed(2)}",
      );
    }
    if (cartCtrl.drinkQuantity.value > 0) {
      summaryLines.add(
        "Drink: ${cartCtrl.drinkName.value} "
        "(x${cartCtrl.drinkQuantity.value})  \$${drinkTotal.toStringAsFixed(2)}",
      );
    }
    summaryLines.add("\nTotal Price: \$${totalAll.toStringAsFixed(2)}");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Summary"),
        content: Text(summaryLines.join("\n")),
        actions: [
          TextButton(
            onPressed: () {
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // Bottom nav bar tap to cartpage
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    }
  }
}
