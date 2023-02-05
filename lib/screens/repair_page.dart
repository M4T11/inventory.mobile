import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'dart:convert';

class RepairPage extends StatefulWidget {
  final Device deviceObject;
  const RepairPage ({ Key? key, required this.deviceObject}): super(key: key);
  
  @override
  _RepairPageState createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  late Map<String, bool?> repairMapCasted;

  // List<Map> availableHobbies = [
  //   {"name": "Foobball", "isChecked": false},
  //   {"name": "Baseball", "isChecked": false},
  //   {
  //     "name": "Video Games",
  //     "isChecked": false,
  //   },
  //   {"name": "Readding Books", "isChecked": false},
  //   {"name": "Surfling The Internet", "isChecked": false},
  //   {"name": "Readding Books", "isChecked": false},
  //   {"name": "Surfling The Internet", "isChecked": false},
  //   {"name": "Readding Books", "isChecked": false},
  //   {"name": "Surfling The Internet", "isChecked": false},
  //   {"name": "Readding Books", "isChecked": false},
  //   {"name": "Surfling The Internet", "isChecked": false},
  //   {"name": "Readding Books", "isChecked": false},
  //   {"name": "Surfling The Internet", "isChecked": false},

  // ];

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
      body: SingleChildScrollView(
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
            Column(
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
          SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Zapisz',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              
                            ),
                          ),
                        ), 
                      ),
                      onTap: () {
                            // Category category = categories.firstWhere((x) => x.name == selectedValueCategory.toString());
                            // Producer producer = producers.firstWhere((x) => x.name == selectedValueProducer.toString());
                            // Provider.of<EanDeviceProvider>(context, listen: false).editEanDevice(
                            //   EanDevice(
                            //   eanDeviceId: widget.eanDeviceObject.eanDeviceId,
                            //   ean: _controllerEAN.text.toString(),
                            //   category: category,
                            //   producer: producer,
                            //   // category: Category(categoryId: 0, name: selectedValueCategory.toString()),
                            //   // producer: Producer(producerId: 0, name: selectedValueProducer.toString()),
                            //   model: _controllerModel.text.toString()));
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDevicePage()));
                          },
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}