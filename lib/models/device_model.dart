import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/location_model.dart';

class Device {
  final int deviceId;
  final String name;
  final String serialNumber;
  final String description;
  final EanDevice eanDevice;
  final Location location;
  final String status;
  final String dateAdded;
  final String qrCode;

Device({
  required this.deviceId,
  required this.name,
  required this.serialNumber,
  required this.description,
  required this.eanDevice,
  required this.location,
  required this.status,
  required this.dateAdded,
  required this.qrCode
});

Map<String, dynamic> toJson() => {
      'device_id': deviceId,
      'name': name,
      'serial_number': serialNumber,
      'description': description,
      'ean_device': eanDevice.toJson(),
      'location': location.toJson(),
      'status': status,
      'date_added': dateAdded,
      'qr_code': qrCode
};

factory Device.fromJson (Map<String,dynamic>json){
  return Device(
      deviceId: json['device_id'],
      name: json['name'],
      serialNumber: json['serial_number'],
      description: json['description'],
      eanDevice: EanDevice.fromJson(json['ean_device']),
      location: Location.fromJson(json['location']),
      status: json['status'],
      dateAdded: json['date_added'],
      qrCode: json['qr_code'],
      );
}

}


