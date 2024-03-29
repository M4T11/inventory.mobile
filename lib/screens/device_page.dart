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
  
  bool flagFiltering = false;
  List <String> selected_category = [];
  // List<Category> category_list = [];
  List<String> category_names_list = [];
  
  List <String> selected_locations = [];
  // List<Location> locations_list = [];
  List<String> locations_names_list = [];

  List <String> selected_producers = [];
  // List<Producer> producers_list = [];
  List<String> producers_names_list = [];

  List <String> selected_ean_devices = [];
  // List<EanDevice> ean_devices_list = [];
  List<EanDevice> ean_devices_per_producer_list = [];
  List<String> ean_devices_names_list = [];
  List<String> ean_devices_per_producer_names_list = [];
  
  List<Device> devices_list = [];
  List<Device> devices_list_filtered = [];
  List<Device> devices_list_to_display = [];

  List<String> device_condition_names_list = ["Nowe", "Używane"]; 
  List <String> selected_condition = [];

  List<String> device_status_names_list = ["Do naprawy", "Do wystawienia", "Wystawione", "Do zdjęć", "Na części", "Sprzedane"]; 
  List <String> selected_status = [];

  List<String> device_return_names_list = ["Zwrot"]; 
  List <String> selected_return = [];
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();

    });
  
    
  }


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // put your logic from initState here
  //     print('HALO');
  //     devices_list = Provider.of<DeviceProvider>(context, listen: false).devices;
  //     devices_list_to_display = devices_list;
  //     for (var age in devices_list_to_display) {
  //     print(age.eanDevice.ean.toString());
  //     }
    
  // }

  void filterDevices() {
    devices_list_filtered = devices_list;

    setState(() {
      if(selected_category.isNotEmpty || selected_locations.isNotEmpty || selected_producers.isNotEmpty || selected_ean_devices.isNotEmpty 
        || selected_condition.isNotEmpty || selected_status.isNotEmpty || selected_return.isNotEmpty) {
        flagFiltering = true;
        if(selected_category.isNotEmpty) {
           devices_list_filtered = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString())).toList();
        }
        if(selected_locations.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())).toList();

        }        
        if(selected_producers.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => selected_producers.contains(element.eanDevice.producer.name.toString())).toList();

        }
        if(selected_ean_devices.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => selected_ean_devices.contains(element.eanDevice.model.toString())).toList();

        }
        if(selected_condition.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => selected_condition.contains(element.condition.toString())).toList();

        }
        if(selected_status.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => selected_status.contains(element.status.toString())).toList();

        }
        if(selected_return.isNotEmpty) {
          devices_list_filtered = devices_list_filtered.where((element) => element.returned == true).toList();
        }
        devices_list_to_display = devices_list_filtered;
        
      }
      else {
        flagFiltering = false;
        devices_list_to_display = devices_list;
      }
    });
    
  }
  
  // void filterDevices() {
  //   devices_list_filtered = devices_list;

  //   setState(() {
  //     // devices_list = devices_list.where((e) => e.eanDevice.category.name == 'Klawiatura')
  //     // .toList();
  //     if(selected_category.isNotEmpty || selected_locations.isNotEmpty || selected_producers.isNotEmpty || selected_ean_devices.isNotEmpty) {
  //       flagFiltering = true;
  //       if(selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
          
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         &&  selected_locations.contains(element.location.name.toString()) 
  //         &&  selected_producers.contains(element.eanDevice.producer.name.toString())
  //         &&  selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
          
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_locations.contains(element.location.name.toString()) 
  //         && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_locations.contains(element.location.name.toString()) 
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //         else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_producers.contains(element.eanDevice.producer.name.toString())
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())  
  //         && selected_producers.contains(element.eanDevice.producer.name.toString())
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_locations.contains(element.location.name.toString())).toList();
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString()) 
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())
  //         && selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_producers.contains(element.eanDevice.producer.name.toString())
  //         && selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isNotEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_producers.contains(element.eanDevice.producer.name.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isNotEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())).toList();
  //       }
  //       else if (selected_category.isNotEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_category.contains(element.eanDevice.category.name.toString())).toList();
  //       }
  //       else if (selected_category.isEmpty && selected_locations.isEmpty && selected_producers.isEmpty && selected_ean_devices.isNotEmpty) {
  //         devices_list_to_display = devices_list_filtered.where((element) => selected_ean_devices.contains(element.eanDevice.model.toString())).toList();
  //       }
  //       // else {
  //       //   devices_list_to_display = devices_list_filtered.where((element) => selected_locations.contains(element.location.name.toString())).toList();

  //       // }
        
  //     }
  //     else {
  //       flagFiltering = false;
  //       devices_list_to_display = devices_list;
  //     }
  //   });
  //   // print(devices_list);
  // }

  

  List<String> updateModels(List<EanDevice> ean_devices_list) {
    if(selected_producers.isNotEmpty) {
      // ean_devices_names_list = ean_devices_list.map((eanDevice) => eanDevice.model).toList();
      ean_devices_per_producer_list = ean_devices_list.where((element) => selected_producers.contains(element.producer.name.toString())).toList();
      ean_devices_per_producer_names_list = ean_devices_per_producer_list.map((eanDevice) => eanDevice.model).toList();
      print(ean_devices_per_producer_names_list);
      // selected_ean_devices.clear();
      ean_devices_names_list = ean_devices_per_producer_names_list;
    } else {
      // selected_ean_devices.clear();
      ean_devices_names_list = ean_devices_list.map((eanDevice) => eanDevice.model).toList();
    }

    return ean_devices_names_list;
  }

  void clearFilters() {
    setState(() {
      selected_category.clear();
      selected_locations.clear();
      selected_producers.clear();
      selected_ean_devices.clear(); 
      selected_condition.clear();
      selected_status.clear();
      selected_return.clear();

      flagFiltering = false;
      devices_list_to_display = devices_list;
                                        
    });
  }
  

  void _showSheet() {
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
              return Consumer4<CategoryProvider, LocationProvider, ProducerProvider, EanDeviceProvider>(
                builder: (context, categoryProvider, locationProvider, producerProvider, eanDeviceProvider, child) {
                  if(categoryProvider.isLoading || locationProvider.isLoading || producerProvider.isLoading || eanDeviceProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                      );
                  }
                  // devices_list = Provider.of<DeviceProvider>(context, listen: false).devices;
                  // category_list = Provider.of<CategoryProvider>(context, listen: false).categories;
                  // locations_list = Provider.of<LocationProvider>(context, listen: false).locations;
                  // producers_list = Provider.of<ProducerProvider>(context, listen: false).producers;
                  // ean_devices_list = Provider.of<EanDeviceProvider>(context, listen: false).eanDevices;
                  
                category_names_list = categoryProvider.categories.map((category) => category.name).toList();
                locations_names_list = locationProvider.locations.map((location) => location.name).toList();
                producers_names_list = producerProvider.producers.map((producer) => producer.name).toList();
                // ean_devices_names_list = eanDeviceProvider.eanDevices.map((eanDevice) => eanDevice.model).toList();
                ean_devices_names_list = updateModels(eanDeviceProvider.eanDevices);
                print(ean_devices_names_list);
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)
                                // style: kTextLabelTheme,
                              ),
                              Text(
                                ' wyniki',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(width: 120,),
                              GestureDetector(
                                child: Container(
                                  // height: 40,
                                  // width: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Wyczyść',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selected_category.clear();
                                    selected_locations.clear();
                                    selected_producers.clear();
                                    selected_ean_devices.clear(); 
                                    selected_condition.clear();
                                    selected_status.clear();     
                                    selected_return.clear();                 
                                  });        
                                  clearFilters(); 
                                }
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
                            onChanged: (val) => {
                              setState(() => selected_producers = val), 
                              print(selected_producers),
                              print(selected_ean_devices),
                              if(selected_ean_devices.isNotEmpty && selected_producers.isNotEmpty) {
                                setState((() {
                                  selected_ean_devices.clear();
                                })),   
                                updateModels(eanDeviceProvider.eanDevices)
                              },
                              
                              filterDevices(), 
                              
                              },
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
                          Container(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Stan',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                                ),
                                
                              ],
                            ),
                          ),
                          ChipsChoice<String>.multiple(
                            value: selected_condition,
                            onChanged: (val) => {setState(() => selected_condition = val), print(selected_condition), filterDevices()},
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: device_condition_names_list,
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
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                                ),
                                
                              ],
                            ),
                          ),
                          ChipsChoice<String>.multiple(
                            value: selected_status,
                            onChanged: (val) => {setState(() => selected_status = val), print(selected_status), filterDevices()},
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: device_status_names_list,
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
                                  'Zwrot',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)
                                ),
                                
                              ],
                            ),
                          ),
                          ChipsChoice<String>.multiple(
                            value: selected_return,
                            onChanged: (val) => {setState(() => selected_return = val), print(selected_return), filterDevices()},
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: device_return_names_list,
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
                },
              );
      });
      },
    );
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
        
        devices_list = value.devices;
        if (!flagFiltering) {
          devices_list_to_display = devices_list;
        }
        
        return RefreshIndicator(
         onRefresh: () async => {value.getAlldevices(), selected_category.clear(), selected_locations.clear(), selected_producers.clear(), selected_ean_devices.clear()},
         child: Column(
           children: [
            SizedBox(height: 25),
            Text(
                'Liczba urządzeń: ' + devices_list_to_display.length.toString(),
                // widget.categoryObject.categoryId.toString() + widget.categoryObject.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  ),
              ),
            SizedBox(height: 25),
            ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
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
                      // child: Text(device.deviceId.toString()),
                      child: Text((index+1).toString()),
                      ),
                      trailing: device.returned ? Icon(Icons.replay) : Icon(null),
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
           ]
         ),
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