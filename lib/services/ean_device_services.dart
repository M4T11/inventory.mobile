import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/ean_device_model.dart';

class EanDeviceService {
  Future <List<EanDevice>> getAll() async {
    const url = 'http://127.0.0.1:8000/ean_devices/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final eanDevices = json.map((e) {
        return EanDevice.fromJson(e);

      }).toList();
      return eanDevices;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future<int> deleteEanDevice(int id) async {
    String url = 'http://127.0.0.1:8000/ean_devices/id/' + id.toString();
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }
  
//   Future<bool> editLocation(Location location) async {
//     String url = 'http://127.0.0.1:8000/locations/id/' + location.locationId.toString();
//     final uri = Uri.parse(url);
//     try{
//       final response = await http.put(
//         uri,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(location.toJson()),
//       );
//     if (response.statusCode == 200) {
//       return true;
//       } else {
//         throw Exception('Failed to edit location');}
//     }
//     catch(e){
//       rethrow;
//       }
//   }

//   Future<bool> addLocation(Location location) async {
//     String url = 'http://127.0.0.1:8000/locations/';
//     final uri = Uri.parse(url);
//     try{
//       final response = await http.post(
//         uri,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(location.toJson()),
//       );
//     if (response.statusCode == 201) {
//       return true;
//       } else {
//         throw Exception('Failed to add location');}
//     }
//     catch(e){
//       rethrow;
//       }
//   }



}