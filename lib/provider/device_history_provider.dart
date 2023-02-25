import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_history_model.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/services/device_history_services.dart';
import 'package:inventoryapp/services/device_services.dart';

class DeviceHistoryProvider extends ChangeNotifier {
  final _deviceHistoryService = DeviceHistoryService();
  List<DeviceHistory> _historyDevices = [];
  List <DeviceHistory> get historyDevices => _historyDevices;
  bool isLoading = false;
  
  Future<void> getAllHistoryDevices(Device device) async {
    isLoading = true;
    notifyListeners();
    
    final response = await _deviceHistoryService.getDeviceHistory(device);
    
    _historyDevices = response;
    isLoading = false;
    notifyListeners();
  }

}