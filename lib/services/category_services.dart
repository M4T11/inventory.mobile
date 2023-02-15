import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventoryapp/models/category_model.dart';

class CategoryService {
  var local = false;


  Future <List<Category>> getAll() async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/categories/';

    } else {
      url = 'http://192.168.50.103:8000/categories/';

    }
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as List;
      final categories = json.map((e) {
        return Category(
          categoryId: e['category_id'], 
          name: e['name']);

      }).toList();
      return categories;
    }
    // throw "Smth went wrong";
    return [];
  }

  Future<int> deleteCategory(int id) async {
    String url = "";
    if (local) {
      url = 'http://127.0.0.1:8000/categories/id/' + id.toString();

    } else {
      url = 'http://192.168.50.103:8000/categories/id/' + id.toString();
    }
    
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    
    return response.statusCode;
  }
  
  Future<bool> editCategory(Category category) async {
    String url = "";

    if (local) {
      url = 'http://127.0.0.1:8000/categories/id/' + category.categoryId.toString();

    } else {
      url = 'http://192.168.50.103:8000/categories/id/' + category.categoryId.toString();
    }
    
    final uri = Uri.parse(url);
    try{
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(category.toJson()),
      );
    if (response.statusCode == 200) {
      return true;
      } else {
        throw Exception('Failed to edit category');}
    }
    catch(e){
      rethrow;
      }
  }

  Future<bool> addCategory(Category category) async {
    String url = "";
    
    if (local) {
      url = 'http://127.0.0.1:8000/categories/';
    } else {
      url = 'http://192.168.50.103:8000/categories/';
    }
    
    final uri = Uri.parse(url);
    try{
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(category.toJson()),
      );
    if (response.statusCode == 201) {
      return true;
      } else {
        throw Exception('Failed to add category');}
    }
    catch(e){
      rethrow;
      }
  }

}