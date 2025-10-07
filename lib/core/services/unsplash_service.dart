import "package:dio/dio.dart";

/// Service for fetching food images from Unsplash API
class UnsplashService {

  UnsplashService(this._dio, this._accessKey);
  final Dio _dio;
  final String _accessKey;

  /// Fetch a random food image URL based on cuisine type
  Future<String?> getFoodImageUrl(String cuisine) async {
    try {
      var query = _getQueryForCuisine(cuisine);
      var response = await _dio.get(
        "https://api.unsplash.com/photos/random",
        queryParameters: {
          "query": query,
          "orientation": "landscape",
          "content_filter": "high",
        },
        options: Options(headers: {"Authorization": "Client-ID $_accessKey"}),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        return data["urls"]["regular"] as String?;
      }
    } catch (e) {
      // Fallback to generic food images
      return _getFallbackImageUrl(cuisine);
    }
    return null;
  }

  /// Get search query for cuisine type
  String _getQueryForCuisine(String cuisine) {
    var cuisineLower = cuisine.toLowerCase();

    // Map cuisines to better search terms
    switch (cuisineLower) {
      case "egyptian":
        return "egyptian food koshary falafel";
      case "street food":
        return "street food egyptian";
      case "indian":
        return "indian food curry biryani";
      case "bakery":
        return "bakery bread pastries egypt";
      case "grill":
        return "grilled meat kebab egypt";
      case "cafe":
        return "cafe coffee egypt nile";
      case "mediterranean":
        return "mediterranean food meze";
      default:
        return "food egyptian cuisine";
    }
  }

  /// Fallback image URLs for when API fails
  String? _getFallbackImageUrl(String cuisine) {
    // For now, return null to use placeholder icons
    // In production, you might want to have cached fallback images
    return null;
  }

  /// Get multiple food images for a cuisine
  Future<List<String?>> getFoodImages(String cuisine, int count) async {
    var images = <String?>[];
    for (var i = 0; i < count; i++) {
      var imageUrl = await getFoodImageUrl(cuisine);
      images.add(imageUrl);
    }
    return images;
  }
}
