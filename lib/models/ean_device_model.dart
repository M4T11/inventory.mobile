import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/producer_model.dart';

class EanDevice {
  final int eanDeviceId;
  final String ean;
  final Category category;
  final Producer producer;
  final String model;

EanDevice({
  required this.eanDeviceId,
  required this.ean,
  required this.category,
  required this.producer,
  required this.model
});

Map<String, dynamic> toJson() => {
      'ean_device_id': eanDeviceId,
      'ean': ean,
      'category': category.toJson(),
      'producer': producer.toJson(),
      'model': model,
};

factory EanDevice.fromJson (Map<String,dynamic>json){
  return EanDevice(
      eanDeviceId: json['ean_device_id'],
      ean: json['ean'],
      category: Category.fromJson(json['category']),
      producer: Producer.fromJson(json['producer']),
      model: json['model'],
      );
}

}


