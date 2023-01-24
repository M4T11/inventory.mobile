import 'package:flutter/material.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/services/ean_device_services.dart';

class EanDeviceProvider extends ChangeNotifier {
  final _eanDeviceService = EanDeviceService();
  List<EanDevice> _eanDevices = [];
  List <EanDevice> get eanDevices => _eanDevices;
  bool isLoading = false;
  
  Future<void> getAllEanDevices() async {
    isLoading = true;
    notifyListeners();
    
    final response = await _eanDeviceService.getAll();
    
    _eanDevices = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteLocations(int id) async {
    isLoading = true;
    notifyListeners();
    _eanDeviceService.deleteEanDevice(id);
    final response = await _eanDeviceService.getAll();
    
    _eanDevices = response;
    isLoading = false;
    notifyListeners();
  }

  // Future<void> editLocations(Location location) async {
  //   isLoading = true;
  //   notifyListeners();
  //   _locationService.editLocation(location);
  //   final response = await _locationService.getAll();
    
  //   _locations = response;
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> addEanDevice(EanDevice eanDevice) async {
    isLoading = true;
    notifyListeners();
    _eanDeviceService.addEanDevice(eanDevice);
    final response = await _eanDeviceService.getAll();
    
    _eanDevices = response;
    isLoading = false;
    notifyListeners();
  }

}