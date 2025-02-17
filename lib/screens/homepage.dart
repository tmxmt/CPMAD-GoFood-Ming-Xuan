import 'package:flutter/material.dart';
import 'package:flutter_project/screens/About.dart';
import '../services/api_service.dart';
import 'detailspage.dart';            
import 'profile.dart';                
import 'cartpage.dart';               

// Example Restaurant model
class Restaurant {
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final String phone;
  final int reviewCount;
  final List<String> categories;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.phone,
    required this.reviewCount,
    required this.categories,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final YelpService _yelpService = YelpService();
  List<Restaurant> restaurants = [];

  String searchFilter = "";
  int _selectedIndex = 0;

  // Filtered restaurants 
  List<Restaurant> get filteredRestaurants {
    if (searchFilter.isEmpty) return restaurants;
    return restaurants
        .where((r) => r.name.toLowerCase().contains(searchFilter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final data = await _yelpService.fetchRestaurants("New York");
      final businesses = data?["businesses"] ?? [];

      setState(() {
        restaurants = businesses.map<Restaurant>((b) {
          final categoryList = b["categories"] as List<dynamic>? ?? [];
          final parsedCategories =
              categoryList.map((cat) => cat["title"].toString()).toList();

          return Restaurant(
            name: b["name"] ?? "No Name",
            imageUrl: b["image_url"] ?? "",
            rating: (b["rating"] ?? 0).toDouble(),
            address: b["location"]?["address1"] ?? "No address",
            phone: b["display_phone"] ?? "No phone",
            reviewCount: b["review_count"] ?? 0,
            categories: parsedCategories,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Error fetching Yelp data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      // Cart
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    } else if (index == 2) {
      // Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AboutPage(),
        ),
      );
    }
    else if (index == 3) {
      // Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Profile(),
        ),
      );
    }
    // If index == 0 or 2, stay at page
  }

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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'GoFood',
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
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for restaurants",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchFilter = value;
                });
              },
            ),
          ),

          // List of Restaurants
          Expanded(
            child: filteredRestaurants.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: restaurant.imageUrl,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: DecorationImage(
                                image: restaurant.imageUrl.isNotEmpty
                                    ? NetworkImage(restaurant.imageUrl)
                                    : const AssetImage('images/placeholder.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 150,
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                restaurant.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Bottom Nav
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
}
