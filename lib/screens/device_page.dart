import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/device_add.dart';
import 'package:inventoryapp/screens/device_details.dart';
import 'package:inventoryapp/screens/device_edit.dart';
import 'package:inventoryapp/services/device_services.dart';
import 'package:provider/provider.dart';
import 'package:chips_choice/chips_choice.dart';


class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  

  List <String> selected_category = [];
  List<Category> category_list = [];
  List<String> category_names_list = [];
  
  List <String> selected_locations = [];
  List<Location> locations_list = [];
  List<String> locations_names_list = [];

  List <String> selected_producers = [];
  List<Producer> producers_list = [];
  List<String> producers_names_list = [];

  List <String> selected_ean_devices = [];
  List<EanDevice> ean_devices_list = [];
  List<EanDevice> ean_devices_per_producer_list = [];
  List<String> ean_devices_names_list = [];
  List<String> ean_devices_per_producer_names_list = [];
  
  List<Device> devices_list = [];
  List<Device> devices_list_filtered = [];
  List<Device> devices_list_to_display = [];
  
  List<String> options = [
    'News', 'Entertainment', 'Politics',
    'Automotive', 'Sports', 'Education',
    'Fashion', 'Travel', 'Food', 'Tech',
    'Science',
  ];

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();

    });
    devices_list = Provider.of<DeviceProvider>(context, listen: false).devices;
    category_list = Provider.of<CategoryProvider>(context, listen: false).categories;
    locations_list = Provider.of<LocationProvider>(context, listen: false).locations;
    producers_list = Provider.of<ProducerProvider>(context, listen: false).producers;
    ean_devices_list = Provider.of<EanDeviceProvider>(context, listen: false).eanDevices;
    
    category_names_list = category_list.map((category) => category.name).toList();
    locations_names_list = locations_list.map((location) => location.name).toList();
    producers_names_list = producers_list.map((producer) => producer.name).toList();
    ean_devices_names_list = ean_devices_list.map((eanDevice) => eanDevice.model).toList();

    devices_list_to_display = devices_list;
  }

  void filterDevices() {
    devices_list_filtered = devices_list;

    setState(() {
      // devices_list = devices_list.where((e) => e.eanDevice.category.name == 'Klawiatura')
      // .toList();
      if(selected_category.isNotEmpty || selected_locations.isNotEmpty || selected_producers.isNotEmpty || selected_ean_devices.isNotEmpty) {
        if(selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
          
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          &&  selected_locations.contains(element.location.name.toString()) 
          &&  selected_producers.contains(element.eanDevice.producer.name.toString())
          &&  selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
          
        }
        else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_locations.contains(element.location.name.toString()) 
          && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
        }
        else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_locations.contains(element.location.name.toString()) 
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
          else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_producers.contains(element.eanDevice.producer.name.toString())
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())  
          && selected_producers.contains(element.eanDevice.producer.name.toString())
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_locations.contains(element.location.name.toString())).toList();
        }
        else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
        }
        else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())
          && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_producers.contains(element.eanDevice.producer.name.toString())
          && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())).toList();
        }
        else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString())).toList();
        }
        else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
          devices_list_to_display = devices_list_filtered.where((element) => selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
        }
        // else {
        //   devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())).toList();

        // }
        
      }
      else {
        devices_list_to_display = devices_list;
      }
    });
    // print(devices_list);
  }

  void updateModels() {
    if(selected_producers.isNotEmpty) {
      // ean_devices_names_list = ean_devices_list.map((eanDevice) => eanDevice.model).toList();
      ean_devices_per_producer_list = ean_devices_list.where((element) => selected_producers.contains(element.producer.name.toString())).toList();
      ean_devices_per_producer_names_list = ean_devices_per_producer_list.map((eanDevice) => eanDevice.model).toList();
      print(ean_devices_per_producer_names_list);
      setState(() {
        selected_ean_devices.clear();
      ean_devices_names_list = ean_devices_per_producer_names_list;
      });
    } else {
      setState(() {
      selected_ean_devices.clear();
      ean_devices_names_list = ean_devices_list.map((eanDevice) => eanDevice.model).toList();
      });
    }

  }

  void _showSheet() {
    print(category_names_list);
    print(locations_names_list);
    print(producers_names_list);
    print(ean_devices_names_list);
    print(Provider.of<CategoryProvider>(context, listen: false).categories);
    if(category_names_list.isNotEmpty && locations_names_list.isNotEmpty && producers_names_list.isNotEmpty && ean_devices_names_list.isNotEmpty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ), // set this to true
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (_, controller) {
                  return SingleChildScrollView(
                    // controller: controller,
                    child: Container(                 
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0),)),
                      // color: Colors.blue[500],
                      // child: ListView.builder(
                        // controller: controller, // set this too
                      //   itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
                      // ),
                      child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Filtruj',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                              // style: kTextLabelTheme,
                            ),
                            Text(
                              ' wyniki',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Kategorie',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                              ),
                              
                            ],
                          ),
                        ),
                        ChipsChoice<String>.multiple(
                          value: selected_category,
                          onChanged: (val) => {setState(() => selected_category = val), print(selected_category), filterDevices()},
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: category_names_list,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          // choiceStyle: C2ChipStyle.outlined(),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Lokalizacje',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                              ),
                              
                            ],
                          ),
                        ),
                        ChipsChoice<String>.multiple(
                          value: selected_locations,
                          onChanged: (val) => {setState(() => selected_locations = val), print(selected_locations), filterDevices()},
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: locations_names_list,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          // choiceStyle: C2ChipStyle.outlined(),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Producent',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                              ),
                              
                            ],
                          ),
                        ),
                        ChipsChoice<String>.multiple(
                          value: selected_producers,
                          onChanged: (val) => {setState(() => selected_producers = val), print(selected_producers), filterDevices(), updateModels()},
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: producers_names_list,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          // choiceStyle: C2ChipStyle.outlined(),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Model',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                              ),
                              
                            ],
                          ),
                        ),
                        ChipsChoice<String>.multiple(
                          value: selected_ean_devices,
                          onChanged: (val) => {setState(() => selected_ean_devices = val), print(selected_ean_devices), filterDevices()},
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: ean_devices_names_list,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          // choiceStyle: C2ChipStyle.outlined(),
                        ),
                    ]),
                    )),
                  );
                },
              );
      });
      },
    );
  } else {
    print('laduje');

  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
       actions: [
        IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {
          _showSheet();
          }),
    ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        // devices_list = value.devices;
        return RefreshIndicator(
         onRefresh: () async => value.getAlldevices(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: devices_list_to_display.length,
          itemBuilder: (context, index) {
            final device = devices_list_to_display[index];
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