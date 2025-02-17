import 'package:flutter/material.dart';
import 'package:flutter_project/screens/contactpage.dart';
import 'homepage.dart'; 
import 'cartpage.dart'; 
import 'profile.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = 2; // "AboutUs" index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    } else if (index == 2) {
      // Stay on AboutUs
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    }
  }

  bool _dummyRadioValue = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                'About Us',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // A radio button to mimic the "circle" in your mockup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _dummyRadioValue,
                        onChanged: (val) {
                          setState(() {
                            // This just toggles the circle for the visual
                            _dummyRadioValue = val!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Company Info
                  const Text(
                    "Company Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "GoFood is a leading food delivery service based in Singapore. "
                    "We strive to connect customers with a wide variety of restaurants, "
                    "offering fast delivery and top-notch service.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Contact Info
                  const Text(
                    "Contact Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Email: support@gofood.sg"),
                  const Text("Phone: +65 1234 5678"),
                  const SizedBox(height: 24),

                  // HQ Location
                  const Text(
                    "Headquarter Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "GoFood HQ\n123 Orchard Road\nSingapore 238888",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // "Contact Us" in blue
                  GestureDetector(
                    onTap: () {
                      // Navigate to ContactPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactPage()),
                      );
                    },
                    child: const Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "AboutUs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
