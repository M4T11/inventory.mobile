import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/producer_add.dart';
import 'package:inventoryapp/screens/producer_details.dart';
import 'package:inventoryapp/screens/producer_edit.dart';
import 'package:inventoryapp/services/producer_services.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class ProducerPage extends StatefulWidget {
  const ProducerPage({Key? key}) : super(key: key);

  @override
  State<ProducerPage> createState() => _ProducerPageState();
}

class _ProducerPageState extends State<ProducerPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
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
      body: Consumer2<ProducerProvider, EanDeviceProvider>(
        builder: (context, producerProvider, eanDeviceProvider, child) {
          if(producerProvider.isLoading || eanDeviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final producers = producerProvider.producers;
        final eanDevices = eanDeviceProvider.eanDevices;
        return RefreshIndicator(
         onRefresh: () async => producerProvider.getAllProducers(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: producers.length,
          itemBuilder: (context, index) {
            final producer = producers[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerEdit(producerObject: producer)));
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
                        EanDevice? eanDevice = eanDevices.firstWhereOrNull((x) => x.producer.name == producer.name);
                        if(eanDevice != null) {
                          MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Nie można usunąć producenta powiązanego z urządzeniami.")
                                    ).show(context);

                        } else {
                        producerProvider.deleteProducers(producer.producerId);
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
                    // child: Text(producer.producerId.toString()),
                    child: Text((index+1).toString()),
                    ),
                    title: Text(producer.name),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProducerDetails(producerObject: producer)));
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
                MaterialPageRoute(builder: (context) => ProducerAdd(forwarding: false,)),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}