import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/producer_model.dart';

class ProducerService {
  var local = false;

  Future <List<Producer>> getAll() async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/producers/';
    } else {
      url = 'http://192.168.50.105:8000/producers/';
    }

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final producers = json.map((e) {
        return Producer(
          producerId: e['producer_id'], 
          name: e['name']);

      }).toList();
      return producers;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future<int> deleteProducer(int id) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/producers/id/' + id.toString();
    } else {
      url = 'http://192.168.50.105:8000/producers/id/' + id.toString();
    }

    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }
  
  Future<bool> editProducer(Producer producer) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/producers/id/' + producer.producerId.toString();
    } else {
      url = 'http://192.168.50.105:8000/producers/id/' + producer.producerId.toString();
    }

    final uri = Uri.parse(url);
    try{
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(producer.toJson()),
      );
    if (response.statusCode == 200) {
      return true;
      } else {
        throw Exception('Failed to edit producer');}
    }
    catch(e){
      rethrow;
      }
  }

  Future<bool> addProducer(Producer producer) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/producers/';
    } else {
      url = 'http://192.168.50.105:8000/producers/';
    }
  
    final uri = Uri.parse(url);
    try{
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(producer.toJson()),
      );
    if (response.statusCode == 201) {
      return true;
      } else {
        throw Exception('Failed to add producer');}
    }
    catch(e){
      rethrow;
      }
  }



}