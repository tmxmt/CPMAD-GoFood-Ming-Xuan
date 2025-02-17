import 'dart:convert';
import 'package:http/http.dart' as http;

class YelpService {
  final String apiKey = "YikvRL3Fq6as_1X_vPxBBF4XIgqT4ecJ0DRF5HUFo4xgrt18coy24E3N1KAHpQRE9kTUfBYwcQgGF9L3X6qTKnwcEggPSR5_gDMY-ioPU8YhSAi_8N7aKasJfpuxZ3Yx"; // Replace with your Yelp API key

  Future<Map<String, dynamic>?> fetchRestaurants(String location) async {
    final String url = "https://api.yelp.com/v3/businesses/search?term=food&location=$location";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load Yelp data");
    }
  }
}
