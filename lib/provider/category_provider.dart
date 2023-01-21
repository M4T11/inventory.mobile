import 'package:flutter/material.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/services/category_services.dart';

class CategoryProvider extends ChangeNotifier {
  final _categoryService = CategoryService();
  List<Category> _categories = [];
  List <Category> get categories => _categories;
  bool isLoading = false;
  
  Future<void> getAllCategories() async {
    isLoading = true;
    notifyListeners();
    
    final response = await _categoryService.getAll();
    
    _categories = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategories(int id) async {
    isLoading = true;
    notifyListeners();
    _categoryService.deleteCategory(id);
    final response = await _categoryService.getAll();
    
    _categories = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> editCategories(Category category) async {
    isLoading = true;
    notifyListeners();
    _categoryService.editCategory(category);
    final response = await _categoryService.getAll();
    
    _categories = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addCategories(Category category) async {
    isLoading = true;
    notifyListeners();
    _categoryService.addCategory(category);
    final response = await _categoryService.getAll();
    
    _categories = response;
    isLoading = false;
    notifyListeners();
  }

}