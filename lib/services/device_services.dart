import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/device_model.dart';

class DeviceService {
  var local = false;
  
  Future <List<Device>> getAll() async {
    String url = "";
    
    if (local) {
      url = 'http://127.0.0.1:8000/devices/';
    } else {
      url = 'http://192.168.50.104:8000/devices/';
    }
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final devices = json.map((e) {
        // print('SERVICE' + Device.fromJson(e).eanDevice.ean.toString());
        return Device.fromJson(e);

      }).toList();
      return devices;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future <Device> getDeviceBySN(String sn) async {
    String url = "";
    
    if (local) {
      url = 'http://127.0.0.1:8000/devices/sn/' + sn;
    } else {
      url = 'http://192.168.50.104:8000/devices/sn/' + sn;
    }
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true));
      final Device device = Device.fromJson(json);
    }
    throw "Don't find device";
    // return;
  }

  Future<int> deleteDevice(int id) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/devices/id/' + id.toString();
    } else {
      url = 'http://192.168.50.104:8000/devices/id/' + id.toString();
    }
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }
  
  Future<bool> editDevice(Device device) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/devices/id/' + device.deviceId.toString();
    } else {
      url = 'http://192.168.50.104:8000/devices/id/' + device.deviceId.toString();
    }
    
    final uri = Uri.parse(url);
    try{
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(device.toJson()),
      );
    if (response.statusCode == 200) {
      return true;
      } else {
        throw Exception('Failed to edit device');}
    }
    catch(e){
      rethrow;
      }
  }

  Future<bool> addDevice(Device device) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/devices/id';
    } else {
      url = 'http://192.168.50.104:8000/devices/id';
    }
    
    final uri = Uri.parse(url);
    try{
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(device.toJson()),
      );
    if (response.statusCode == 201) {
      return true;
      } else {
        throw Exception('Failed to add device');}
    }
    catch(e){
      rethrow;
      }
  }

}