import 'package:flutter_mvvm/data/network/network_api_services.dart';
import 'package:flutter_mvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  // PROVINCE
  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/province');
      List<Province> result = [];
      // Periksa response dan pastikan strukturnya sesuai
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      } else {
        throw Exception(
            "Failed to load provinces: ${response['rajaongkir']['status']['description']}");
      }
      return result;
    } catch (e) {
      throw Exception('Error fetching province list: $e');
    }
  }

  // CITY
  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/city');
      List<City> result = [];
      // dilihat berdasarkan strukturnya
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }
      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provId) {
          selectedCities.add(c);
        }
      }
      return selectedCities;
    } catch (e) {
      throw e;
    }
  }

  // COST
  Future<List<Costs>> getCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int itemWeight,
    String courier,
  ) async {
    try {
      // Log input parameters
      print("[Request Parameters]");
      print("Origin: $origin");
      print("Origin Type: $originType");
      print("Destination: $destination");
      print("Destination Type: $destinationType");
      print("Item Weight: $itemWeight");
      print("Courier: $courier");

      // Send a POST request
      final response = await _apiServices.postApiResponse(
        '/api/cost',
        {
          "origin": origin,
          "originType": originType,
          "destination": destination,
          "destinationType": destinationType,
          "weight": itemWeight,
          "courier": courier,
        },
      );

      // Log the full response to examine its structure
      print("API Response: $response");

      // Check API response status
      final statusCode = response['rajaongkir']['status']['code'];
      if (statusCode == 200) {
        // Transform API response to a list of Costs
        final results = response['rajaongkir']['results'] as List<dynamic>;
        final costs = results.expand((result) {
          final costList = result['costs'] as List;
          return costList
              .map((cost) => Costs.fromJson(cost as Map<String, dynamic>));
        }).toList();

        return costs;
      } else {
        // Handle API error with a descriptive message
        final errorMessage = response['rajaongkir']['status']['description'];
        throw Exception("Error: $errorMessage");
      }
    } catch (error) {
      // Print and rethrow the error
      print("Error in getCost(): $error");
      rethrow;
    }
  }
}
