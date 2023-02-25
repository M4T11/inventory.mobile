import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/device_history_model.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:motion_toast/motion_toast.dart'; 

class DeviceHistoryService {
  var local = false;
  
  Future <List<DeviceHistory>> getAll() async {
    String url = "";
    
    if (local) {
      url = 'http://127.0.0.1:8000/deviceshistories/';
    } else {
      url = 'http://192.168.50.105:8000/deviceshistories/';
    }
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final historyDevices = json.map((e) {
        // print('SERVICE' + Device.fromJson(e).eanDevice.ean.toString());
        return DeviceHistory.fromJson(e);

      }).toList();
      return historyDevices;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future<List<DeviceHistory>> getDeviceHistory(Device device) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/deviceshistories/id/' + device.deviceId.toString();
    } else {
      url = 'http://192.168.50.105:8000/deviceshistories/id/' + device.deviceId.toString();
    }
    
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final historyDevices = json.map((e) {
        // print('SERVICE' + Device.fromJson(e).eanDevice.ean.toString());
        return DeviceHistory.fromJson(e);

      }).toList();
      return historyDevices;
    }
    // throw "Smth went wrong";
    return [];
  }

}