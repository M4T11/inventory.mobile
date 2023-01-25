import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/screens/device_add.dart';
import 'package:inventoryapp/screens/device_details.dart';
import 'package:inventoryapp/screens/device_edit.dart';
import 'package:inventoryapp/services/device_services.dart';
import 'package:provider/provider.dart';


class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final devices = value.devices;
        return RefreshIndicator(
         onRefresh: () async => value.getAlldevices(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceEdit(deviceObject: device)));
                      }),
                      icon: Icons.edit,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                ]),
                endActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        // Future<int> response = CategoryService().deleteCategory(category.categoryId);
                        value.deleteDevice(device.deviceId);
                        // setState(() { categories.removeWhere((element) => element.categoryId == category.categoryId); });
                        // setState(() { value.getAllCategories(); });                     
                      }),
                      icon: Icons.delete,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      ),
                ]),           
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Text(device.deviceId.toString()),
                    // child: Text((index+1).toString()),
                    ),
                    title: Text(device.eanDevice.producer.name + " " + device.eanDevice.model),
                    subtitle: Text(device.name + " " + device.serialNumber),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeviceDetails(deviceObject: device)),);
              },
            );
          }),
          );   
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeviceAdd()),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}