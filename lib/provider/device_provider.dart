import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/services/device_services.dart';

class DeviceProvider extends ChangeNotifier {
  final _deviceService = DeviceService();
  List<Device> _devices = [];
  List <Device> get devices => _devices;
  bool isLoading = false;
  
  Future<void> getAlldevices() async {
    isLoading = true;
    notifyListeners();
    
    final response = await _deviceService.getAll();
    
    _devices = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteDevice(int id) async {
    isLoading = true;
    notifyListeners();
    _deviceService.deleteDevice(id);
    final response = await _deviceService.getAll();
    
    _devices = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> editDevice(Device device) async {
    isLoading = true;
    notifyListeners();
    _deviceService.editDevice(device);
    final response = await _deviceService.getAll();
    
    _devices = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    isLoading = true;
    notifyListeners();
    _deviceService.addDevice(device);
    final response = await _deviceService.getAll();
    
    _devices = response;
    isLoading = false;
    notifyListeners();
  }

}