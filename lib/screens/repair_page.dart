import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/screens/main_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';


class RepairPage extends StatefulWidget {
  final Device deviceObject;
  const RepairPage ({ Key? key, required this.deviceObject}): super(key: key);
  
  @override
  _RepairPageState createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  late Map<String, bool?> repairMapCasted;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map repairMap = jsonDecode(widget.deviceObject.description);
    print(repairMap);
    repairMapCasted= Map<String, bool?>.from(repairMap);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () {
            // Map mapDescriptionToSave = json.encode(repairMapCasted);
            Map mapDescriptionToSave = repairMapCasted.map((key, value) => MapEntry('"$key"', value));
            Provider.of<DeviceProvider>(context, listen: false).editDevice(
              Device(
              deviceId: widget.deviceObject.deviceId,
              name: widget.deviceObject.name,
              serialNumber: widget.deviceObject.serialNumber,
              description: mapDescriptionToSave.toString(),
              eanDevice: widget.deviceObject.eanDevice,
              location: widget.deviceObject.location,
              quantity: widget.deviceObject.quantity.toInt(),
              condition: widget.deviceObject.condition.toString(),
              status: widget.deviceObject.status.toString(),
              dateAdded: "2023-01-01",
              qrCode: widget.deviceObject.qrCode.toString(),
              ));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));

          },
          child: const Center(
            child: Text('ZAPISZ'),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Lista rzeczy do wykonania:',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
      
              // The checkboxes will be here
              Container(
                height: 0.65 * MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                      children: repairMapCasted.keys.map((String key) {
                    return CheckboxListTile(
                        value: repairMapCasted[key],
                        title: Text(key),
                        onChanged: (newValue) {
                          setState(() {
                            print(repairMapCasted[key]);
                            print(newValue);
                            repairMapCasted[key] = newValue;
                            print(repairMapCasted);
                          });
                        });
                  }).toList()),
                ),
              ),
      
              // // Display the result here
              // const SizedBox(height: 10),
              // const Divider(),
              // const SizedBox(height: 10),
              // Wrap(
              //   children: availableHobbies.map((hobby) {
              //     if (hobby["isChecked"] == true) {
              //       return Card(
              //         elevation: 3,
              //         color: Colors.amber,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(hobby["name"]),
              //         ),
              //       );
              //     }
      
              //     return Container();
              //   }).toList(),
              // )
            ]),
          ),
        ),
      ),
    );
  }
}