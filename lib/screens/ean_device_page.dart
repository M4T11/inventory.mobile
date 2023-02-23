import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/screens/ean_device_add.dart';
import 'package:inventoryapp/screens/ean_device_details.dart';
import 'package:inventoryapp/screens/ean_device_edit.dart';
import 'package:inventoryapp/screens/location_edit.dart';
import 'package:inventoryapp/services/ean_device_services.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class EanDevicePage extends StatefulWidget {
  const EanDevicePage({Key? key}) : super(key: key);

  @override
  State<EanDevicePage> createState() => _EanDevicePageState();
}

class _EanDevicePageState extends State<EanDevicePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
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
      body: Consumer2<EanDeviceProvider, DeviceProvider>(
        builder: (context, eanDeviceProvider, deviceProvider, child) {
          if(eanDeviceProvider.isLoading || deviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final eanDevices = eanDeviceProvider.eanDevices;
        final devices = deviceProvider.devices;
        return RefreshIndicator(
         onRefresh: () async => eanDeviceProvider.getAllEanDevices(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: eanDevices.length,
          itemBuilder: (context, index) {
            final eanDevice = eanDevices[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDeviceEdit(eanDeviceObject: eanDevice)));
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
                        Device? device = devices.firstWhereOrNull((x) => x.eanDevice.ean == eanDevice.ean);
                        if(device != null) {
                          MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Nie można usunąć urządzenia EAN powiązanego z urządzeniami.")
                                    ).show(context);

                        } else {
                          eanDeviceProvider.deleteEanDevice(eanDevice.eanDeviceId);
                        }
                                        
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
                    // child: Text(eanDevice.eanDeviceId.toString()),
                    child: Text((index+1).toString()),
                    ),
                    title: Text(eanDevice.producer.name + " " + eanDevice.model),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EanDeviceDetails(eanDeviceObject: eanDevice)),);
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
                MaterialPageRoute(builder: (context) => EanDeviceAdd(forwarding: false,)),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}