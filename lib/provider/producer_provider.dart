import 'package:flutter/material.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/services/producer_services.dart';

class ProducerProvider extends ChangeNotifier {
  final _producerService = ProducerService();
  List<Producer> _producers = [];
  List <Producer> get producers => _producers;
  bool isLoading = false;
  
  Future<void> getAllProducers() async {
    isLoading = true;
    notifyListeners();
    
    final response = await _producerService.getAll();
    
    _producers = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProducers(int id) async {
    isLoading = true;
    notifyListeners();
    _producerService.deleteProducer(id);
    final response = await _producerService.getAll();
    
    _producers = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> editProducers(Producer producer) async {
    isLoading = true;
    notifyListeners();
    _producerService.editProducer(producer);
    final response = await _producerService.getAll();
    
    _producers = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProducer(Producer producer) async {
    isLoading = true;
    notifyListeners();
    _producerService.addProducer(producer);
    final response = await _producerService.getAll();
    
    _producers = response;
    isLoading = false;
    notifyListeners();
  }

}