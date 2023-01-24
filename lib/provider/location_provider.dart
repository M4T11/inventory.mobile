import 'package:flutter/material.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/services/location_services.dart';

class LocationProvider extends ChangeNotifier {
  final _locationService = LocationService();
  List<Location> _locations = [];
  List <Location> get locations => _locations;
  bool isLoading = false;
  
  Future<void> getAllLocations() async {
    isLoading = true;
    notifyListeners();
    
    final response = await _locationService.getAll();
    
    _locations = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteLocations(int id) async {
    isLoading = true;
    notifyListeners();
    _locationService.deleteLocation(id);
    final response = await _locationService.getAll();
    
    _locations = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> editLocations(Location location) async {
    isLoading = true;
    notifyListeners();
    _locationService.editLocation(location);
    final response = await _locationService.getAll();
    
    _locations = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addLocation(Location location) async {
    isLoading = true;
    notifyListeners();
    _locationService.addLocation(location);
    final response = await _locationService.getAll();
    
    _locations = response;
    isLoading = false;
    notifyListeners();
  }

}