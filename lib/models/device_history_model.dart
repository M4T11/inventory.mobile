import 'package:inventoryapp/models/device_model.dart';

class DeviceHistory {
  final int historyId;
  final String event;
  final Device device;
  final String date;

DeviceHistory({
  required this.historyId,
  required this.event,
  required this.device,
  required this.date
});

Map<String, dynamic> toJson() => {
      'history_id': historyId,
      'event': event,
      'device': device.toJson(),
      'date': date
};

factory DeviceHistory.fromJson (Map<String,dynamic>json){
  return DeviceHistory(
      historyId: json['history_id'],
      event: json['event'],
      device: Device.fromJson(json['device']),
      date: json['date']
      );
}

}


