import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/model/model.dart';
import 'package:flutter_mvvm/repository/home_repository.dart';

class HomeVm with ChangeNotifier {
  final _homeRepo = HomeRepository();

// PROVINCE
  ApiResponse<List<Province>> provinceList = ApiResponse.loading();

  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

// PROVINCE ORIGIN
  ApiResponse<List<Province>> provinceOriginList = ApiResponse.notStarted();
  setProvinceOriginList(ApiResponse<List<Province>> response) {
    provinceOriginList = response;
    notifyListeners();
  }

  Future<dynamic> getProvinceOriginList() async {
    setProvinceOriginList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceOriginList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceOriginList(ApiResponse.error(error.toString()));
    });
  }

  // PROVINCE DESTINATION
  ApiResponse<List<Province>> provinceDestinationList =
      ApiResponse.notStarted();
  setProvinceDestinationList(ApiResponse<List<Province>> response) {
    provinceDestinationList = response;
    notifyListeners();
  }

  Future<dynamic> getProvinceDestinationList() async {
    setProvinceDestinationList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceDestinationList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceDestinationList(ApiResponse.error(error.toString()));
    });
  }

  // CITY ORIGIN
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  Future<dynamic> getCityOriginList(var provId) async {
    setCityOriginList(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }

  // CITY DESTINATION
  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();
  setCityDestinationList(ApiResponse<List<City>> response) {
    cityDestinationList = response;
    notifyListeners();
  }

  Future<dynamic> getCityDestinationList(var provId) async {
    setCityDestinationList(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityDestinationList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityDestinationList(ApiResponse.error(error.toString()));
    });
  }

  // COST
  ApiResponse<List<Costs>> costList = ApiResponse.loading();

  void setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  Future<dynamic> getCost({
    required String origin,
    required String originType,
    required String destination,
    required String destinationType,
    required int itemWeight,
    required String courier,
  }) async {
    // Set state to loading
    setCostList(ApiResponse.loading());
    
    try {
      // Call the repository to get cost data
      final costs = await _homeRepo.getCost(
        origin,
        originType,
        destination,
        destinationType,
        itemWeight,
        courier,
      );

      // Update the state with the fetched data
      setCostList(ApiResponse.completed(costs));
    } catch (error) {
      // Log error and update state with the error message
      print("Error in getCost: $error");
      setCostList(ApiResponse.error(error.toString()));
    }
  }
}
