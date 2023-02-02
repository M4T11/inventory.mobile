import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/ean_device_model.dart';

class EanDeviceService {
  var local = false;

  Future <List<EanDevice>> getAll() async {
    String url = "";

    if (local) {
      url = 'http://127.0.0.1:8000/ean_devices/';
    } else {
      url = 'http://192.168.50.104:8000/ean_devices/';
    }

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final eanDevices = json.map((e) {
        return EanDevice.fromJson(e);

      }).toList();
      return eanDevices;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future<int> deleteEanDevice(int id) async {
    String url = "";

    if (local) {
      url = 'http://127.0.0.1:8000/ean_devices/id/' + id.toString();
    } else {
      url = 'http://192.168.50.104:8000/ean_devices/id/' + id.toString();
    }
    
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }
  
  Future<bool> editEanDevice(EanDevice eanDevice) async {
    String url = "";

    if (local) {
      url = 'http://127.0.0.1:8000/ean_devices/id/' + eanDevice.eanDeviceId.toString();
    } else {
      url = 'http://192.168.50.104:8000/ean_devices/id/' + eanDevice.eanDeviceId.toString();
    }
    
    final uri = Uri.parse(url);
    try{
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(eanDevice.toJson()),
      );
    if (response.statusCode == 200) {
      return true;
      } else {
        throw Exception('Failed to edit EAN Device');}
    }
    catch(e){
      rethrow;
      }
  }

  Future<bool> addEanDevice(EanDevice eanDevice) async {
    String url = "";

    if (local) {
      url = 'http://127.0.0.1:8000/ean_devices/id';
    } else {
      url = 'http://192.168.50.104:8000/ean_devices/id';
    }

    final uri = Uri.parse(url);
    try{
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(eanDevice.toJson()),
      );
    if (response.statusCode == 201) {
      return true;
      } else {
        throw Exception('Failed to add EAN Device');}
    }
    catch(e){
      rethrow;
      }
  }



}