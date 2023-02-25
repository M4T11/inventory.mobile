import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/provider/device_history_provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:inventoryapp/screens/ean_device_add.dart';
import 'package:inventoryapp/screens/location_add.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:convert';
import 'package:quiver/collection.dart';
import 'package:collection/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class DeviceEdit extends StatefulWidget {
  final Device deviceObject;
  const DeviceEdit ({ Key? key, required this.deviceObject}): super(key: key);
  
  @override
  State<DeviceEdit> createState() => _DeviceEditState();
}

class _DeviceEditState extends State<DeviceEdit> with SingleTickerProviderStateMixin{

  List<String> itemsDescription = [
  'Do wyczyszczenia',
  'Do sprawdzenia',
  ];
  List<String> itemsDescriptionMouse = [
        'Do wyczyszczenia',
        'Do sprawdzenia',
        'Nie działa LPM',
        'Nie działa PPM',
        'Switche do wymiany',
        'Enkoder do wymiany',
        'Boczki do przyklejenia',
        'Klawisze się ruszają',
        'Przewód do wymiany',
        'Dołożyc nadajnik',
        ];

  List<String> itemsDescriptionHeadphones =[
      'Do wyczyszczenia',
      'Do sprawdzenia',
      'Potencjometr do wymiany',
      'Nie działa PS',
      'Nie działa LS',
      'Jack do wymiany'
      ];
  List<String> selectedItemsDescription = [];
  late Map selected_copy;
  Map mapDescriptionToSave = {};

  List<String> deviceCondition = ["Nowe", "Używane"]; 
  List<String> deviceStatus = ["Do naprawy", "Do wystawienia", "Wystawione", "Do zdjęć", "Na części", "Sprzedane"]; 

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
      Provider.of<DeviceHistoryProvider>(context, listen: false).getAllHistoryDevices(widget.deviceObject);
    });
    selectedValueEanDevice= widget.deviceObject.eanDevice.producer.name + " " + widget.deviceObject.eanDevice.model + " (" + widget.deviceObject.eanDevice.ean + ")";
    selectedValueLocation = widget.deviceObject.location.name;
    selectedValueStatus = widget.deviceObject.status;
    selectedValueCondition = widget.deviceObject.condition;
    quantity = widget.deviceObject.quantity.toDouble();
    _controllerSerialnumber.text = widget.deviceObject.serialNumber.toString();
    _controllerName.text = widget.deviceObject.name.toString();
    _controllerDescription.text = widget.deviceObject.description.toString(); 
    _controllerID.text = widget.deviceObject.qrCode.toString();

    spinReadOnly = false;
    spinEnabled = true;
    returnEAN = false;
    returnLocationName = false;

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        if(_tabController.index ==1) {
          Provider.of<DeviceHistoryProvider>(context, listen: false).getAllHistoryDevices(widget.deviceObject);

        }        
      });
    });

    // _controllerSerialnumber.addListener((){
    //         //here you have the changes of your textfield
    //         if (_controllerSerialnumber.text.isNotEmpty) {
    //           spinReadOnly = true;
    //           spinEnabled = false;
    //         } else {
    //           spinReadOnly = false;
    //           spinEnabled = true;
    //         }
    //         //use setState to rebuild the widget
    //         setState(() {});
    //     });

    Map selected = json.decode(widget.deviceObject.description);
    selected_copy = json.decode(widget.deviceObject.description);

    selected.keys.forEach((key) {
      // print(key);
      selectedItemsDescription.add(key);
    });

    if(widget.deviceObject.eanDevice.category.name.toString() == 'Mysz') {

      if(listsEqual(itemsDescriptionMouse, selectedItemsDescription)) {
        itemsDescription = itemsDescriptionMouse;
      } else {
        var missing = selectedItemsDescription.where((e) => !itemsDescriptionMouse.contains(e));
        
        itemsDescription = itemsDescriptionMouse + missing.toList();
      }

      

    } else if (widget.deviceObject.eanDevice.category.name.toString() == 'Klawiatura') {

      itemsDescription = itemsDescription;

      if(listsEqual(itemsDescription, selectedItemsDescription)) {
        itemsDescription = itemsDescription;
      } else {
        var missing = selectedItemsDescription.where((e) => !itemsDescription.contains(e));
      
        itemsDescription = itemsDescription + missing.toList();
      }

    } else if (widget.deviceObject.eanDevice.category.name.toString() == 'Słuchawki') {

      
      if(listsEqual(itemsDescriptionMouse, selectedItemsDescription)) {
        itemsDescription = itemsDescriptionHeadphones;
      } else {
        var missing = selectedItemsDescription.where((e) => !itemsDescriptionHeadphones.contains(e));
      
        itemsDescription = itemsDescriptionHeadphones + missing.toList();
      }
    }
    
  }

  void setEanDevice(List<EanDevice> list, String ean) {
    EanDevice eanDevice = list.firstWhere((x) => x.ean == ean);
    selectedValueEanDevice = eanDevice.producer.name + " " + eanDevice.model + " (" + eanDevice.ean + ")";

    if(eanDevice.category.name == 'Mysz') {
      selectedItemsDescription.clear();
      itemsDescription = itemsDescriptionMouse;

    } else if (eanDevice.category.name == 'Klawiatura') {
        selectedItemsDescription.clear();
        itemsDescription = itemsDescription;

    } else if (eanDevice.category.name == 'Słuchawki') {
          selectedItemsDescription.clear();
          itemsDescription = itemsDescriptionHeadphones;
    }

  }

  void setLocation(List<Location> list, String locationName) {
    Location location = list.firstWhere((x) => x.name == locationName);
    selectedValueLocation = location.name;
  }

  TextEditingController _controllerSerialnumber = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerDescription = new TextEditingController();
  TextEditingController _controllerID = new TextEditingController();
  TextEditingController _textControllerAlertDialog = new TextEditingController();

  late TabController _tabController;
  late String eanCode;
  late String locationName;
  late bool returnEAN;
  late bool returnLocationName;
  late bool spinEnabled;
  late bool spinReadOnly;
  late double quantity;
  String? selectedValueEanDevice;
  final TextEditingController textEditingControllerEanDevice = TextEditingController();
  String? selectedValueLocation;
  final TextEditingController textEditingControllerLocation = TextEditingController();
  String? selectedValueStatus;
  final TextEditingController textEditingControllerStatus = TextEditingController();
  String? selectedValueCondition;
  final TextEditingController textEditingControllerCondition = TextEditingController();
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerSerialnumber.dispose();
    _controllerName.dispose();
    _controllerDescription.dispose();
    _controllerID.dispose();
    textEditingControllerEanDevice.dispose();
    textEditingControllerLocation.dispose();
    textEditingControllerStatus.dispose();
    textEditingControllerCondition.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
          title: const Text('Inventory App'),
          backgroundColor: Color(0xff235d3a),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Edycja",
              ),
              new Tab(
                text: "Historia",
              ),
            ],
            controller: _tabController,
          ),
          ),
          body: Consumer4<EanDeviceProvider, LocationProvider, DeviceProvider, DeviceHistoryProvider>(
            builder: (context, eanDeviceProvider, locationProvider, deviceProvider, deviceHistoryProvider, child) {
              if(eanDeviceProvider.isLoading || locationProvider.isLoading || deviceProvider.isLoading || deviceHistoryProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                  );
              }
              final eanDevices = eanDeviceProvider.eanDevices;
              final locations = locationProvider.locations;
              final devices = deviceProvider.devices;
              final deviceHistory = deviceHistoryProvider.historyDevices;
    
              if(returnEAN) {
                setEanDevice(eanDevices, eanCode);
                returnEAN = false;
              }
              if(returnLocationName) {
                setLocation(locations, locationName);
                returnLocationName = false;
              }
              return TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          // SizedBox(height: 25),
                          // Text(
                          //   'Edytuj urządzenie',
                          //   // widget.categoryObject.categoryId.toString() + widget.categoryObject.name.toString(),
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 24,
                          //     ),
                          // ),
                          // SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _controllerName,
                                textAlign: TextAlign.center,
                                // initialValue: widget.categoryObject.name.toString(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Wprowadź nazwę przedmiotu (opcjonalne)',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _controllerSerialnumber,
                                      textAlign: TextAlign.center,
                                      // initialValue: widget.categoryObject.name.toString(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Wprowadź nr seryjny przedmiotu',
                                      ),
                                    ),
                                  ),
                                IconButton(
                                  icon: Icon(Icons.camera_alt_rounded),
                                  onPressed: () async {
                                      var camera_result_serial_number = await BarcodeScanner.scan();
                                      print(camera_result_serial_number.type); // The result type (barcode, cancelled, failed)
                                      print(camera_result_serial_number.rawContent); // The barcode content
                                      print(camera_result_serial_number.format); // The barcode format (as enum)
                                      print(camera_result_serial_number.formatNote); // If a unknown format was sc
                                      
                                      if(camera_result_serial_number.format != 'unknown' && camera_result_serial_number.type != 'Cancelled' && camera_result_serial_number.rawContent.isNotEmpty) {
                                        _controllerSerialnumber.text = camera_result_serial_number.rawContent.toString();
                                      }
                                  },
                                ),
                              ],
                            ),               
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _controllerID,
                                      textAlign: TextAlign.center,
                                      // initialValue: widget.categoryObject.name.toString(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nadaj unikalne ID',
                                      ),
                                    ),
                                  ),
                                IconButton(
                                  icon: Icon(Icons.camera_alt_rounded),
                                  onPressed: () async {
                                      var camera_result_serial_number = await BarcodeScanner.scan();
                                      print(camera_result_serial_number.type); // The result type (barcode, cancelled, failed)
                                      print(camera_result_serial_number.rawContent); // The barcode content
                                      print(camera_result_serial_number.format); // The barcode format (as enum)
                                      print(camera_result_serial_number.formatNote); // If a unknown format was sc
                                      
                                      if(camera_result_serial_number.format != 'unknown' && camera_result_serial_number.type != 'Cancelled' && camera_result_serial_number.rawContent.isNotEmpty) {
                                        _controllerID.text = camera_result_serial_number.rawContent.toString();
                                      }
                                  },
                                ),
                              ],
                            ),               
                          ),     
                          // SizedBox(height: 5),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey[200],
                          //       border: Border.all(color: Colors.white),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: TextField(
                          //       controller: _controllerDescription,
                          //       textAlign: TextAlign.center,
                          //       // initialValue: widget.categoryObject.name.toString(),
                          //       decoration: InputDecoration(
                          //         border: InputBorder.none,
                          //         hintText: 'Wprowadź opis przedmiotu (opcjonalne)',
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Text(
                                    'Wybierz urządzenie EAN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: eanDevices.map((item) => DropdownMenuItem<String>(
                                  value: item.producer.name + " " + item.model + " (" + item.ean + ")",
                                  child: Text(
                                    item.producer.name + " " + item.model + " (" + item.ean + ")",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )).toList(),
                                value: selectedValueEanDevice,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValueEanDevice = value as String;
                                    var ean_device_selected = selectedValueEanDevice.toString().split(" ");
                                    var ean_selected = ean_device_selected.last.substring(1, ean_device_selected.last.length - 1);;
                                    EanDevice eanDevice = eanDevices.firstWhere((x) => x.ean == ean_selected.toString());
                                    if(eanDevice.category.name == 'Mysz') {
          
                                        selectedItemsDescription.clear();
                                        itemsDescription = itemsDescriptionMouse;
          
                                    } else if (eanDevice.category.name == 'Klawiatura') {
                                        selectedItemsDescription.clear();
                                        itemsDescription = itemsDescription;
          
                                    } else if (eanDevice.category.name == 'Słuchawki') {
                                        selectedItemsDescription.clear();
                                        itemsDescription = itemsDescriptionHeadphones;
                                    }
                                    });
                                  },
                                  iconSize: 0.0,
                                  buttonHeight: 50,
                                  // buttonWidth: 200,
                                  itemHeight: 40,
                                  dropdownMaxHeight: 200,
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black26,
                                      ),
                                      color: Colors.grey[200],
                                      ),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                    ),
                                  searchController: textEditingControllerEanDevice,
                                  searchInnerWidget: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    controller: textEditingControllerEanDevice,
                                    decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Wyszukaj urządzenie EAN...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // searchMatchFn: (item, searchValue) {
                                  //   return (item.value.toString().contains(searchValue));
                                  //   },
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        textEditingControllerEanDevice.clear();
                                        }
                                        },
                                  )),
                                  IconButton(
                                  icon: Icon(Icons.camera_alt_rounded),
                                  onPressed: () async {
                                    // do something
                                    var camera_result_ean = await BarcodeScanner.scan();
                                      print(camera_result_ean.type); // The result type (barcode, cancelled, failed)
                                      print(camera_result_ean.rawContent); // The barcode content
                                      print(camera_result_ean.format); // The barcode format (as enum)
                                      print(camera_result_ean.formatNote); // If a unknown format was sc
                                      
                                      if(camera_result_ean.format != 'unknown' && camera_result_ean.type != 'Cancelled' && camera_result_ean.rawContent.isNotEmpty) {
                                        EanDevice temp_ean = eanDevices.firstWhere((x) => x.ean == camera_result_ean.rawContent.toString());
                                        
                                        if (temp_ean != null) {
                                          setState(() {
                                          selectedValueEanDevice = temp_ean.producer.name + " " + temp_ean.model + " (" + temp_ean.ean + ")";
                                          EanDevice eanDevice = eanDevices.firstWhere((x) => x.ean == temp_ean.ean.toString());
                                          
                                          if(eanDevice.category.name == 'Mysz') {
          
                                              selectedItemsDescription.clear();
                                              itemsDescription = itemsDescriptionMouse;
          
                                          } else if (eanDevice.category.name == 'Klawiatura') {
                                              selectedItemsDescription.clear();
                                              itemsDescription = itemsDescription;
          
                                          } else if (eanDevice.category.name == 'Słuchawki') {
                                              selectedItemsDescription.clear();
                                              itemsDescription = itemsDescriptionHeadphones;
                                          }
                                          
                                        },);
                                        } else {
                                          showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                    title: const Text('UWAGA'),
                                                    content: const Text('Nie znaleziono urządzenia o podanym numerze EAN'),
                                                    actions: [
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.pink,
                                                      ),
                                                      child: Text('Anuluj',),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.green,
                                                      ),
                                                      child: Text('Dodaj'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDeviceAdd(forwarding: true,)));
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EanDeviceAdd(forwarding: true, eanCode: camera_result_ean.rawContent.toString(),)),).then((value) => {
                                                          returnEAN = value["returnEAN"],
                                                          eanCode = value["ean"]
                                                      });                                            
                                                      },
                                                    ),
                                                  ]    
                                                  ));
                                        }              
                                      }
                                  },
                                  ),
                                  Positioned(
                                    right: 35, 
                                  child: IconButton(
                                    onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDeviceAdd(forwarding: true,))).then((value) => {
                                    returnEAN = value["returnEAN"],
                                    eanCode = value["ean"]
                                    });}, 
                                    icon: Icon(Icons.add))),
          
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Text(
                                    'Wybierz lokalizację przedmiotu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: locations.map((item) => DropdownMenuItem<String>(
                                  value: item.name,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )).toList(),
                                value: selectedValueLocation,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValueLocation = value as String;
                                    });
                                  },
                                  iconSize: 0.0,
                                  buttonHeight: 50,
                                  // buttonWidth: 200,
                                  itemHeight: 40,
                                  dropdownMaxHeight: 200,
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black26,
                                      ),
                                      color: Colors.grey[200],
                                      ),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                    ),
                                  searchController: textEditingControllerLocation,
                                  searchInnerWidget: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    controller: textEditingControllerLocation,
                                    decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Wyszukaj lokalizację...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // searchMatchFn: (item, searchValue) {
                                  //   return (item.value.toString().contains(searchValue));
                                  //   },
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        textEditingControllerLocation.clear();
                                        }
                                        },
                                  )),
                                IconButton(
                                  icon: Icon(Icons.camera_alt_rounded),
                                  onPressed: () async {
                                    // do something
                                    var camera_result_location = await BarcodeScanner.scan();
                                      print(camera_result_location.type); // The result type (barcode, cancelled, failed)
                                      print(camera_result_location.rawContent); // The barcode content
                                      print(camera_result_location.format); // The barcode format (as enum)
                                      print(camera_result_location.formatNote); // If a unknown format was sc
                                      
                                      if(camera_result_location.format != 'unknown' && camera_result_location.type != 'Cancelled' && camera_result_location.rawContent.isNotEmpty) {
                                        Location temp_location = locations.firstWhere((x) => x.name == camera_result_location.rawContent.toString());
                                        print(temp_location.name);
                                        if(temp_location != null) {
                                          setState(() {
                                          selectedValueLocation = temp_location.name;
                                          },);
                                        } else {
                                          showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                    title: const Text('UWAGA'),
                                                    content: const Text('Nie znaleziono lokalizacji'),
                                                    actions: [
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.pink,
                                                      ),
                                                      child: Text('Anuluj',),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.green,
                                                      ),
                                                      child: Text('Dodaj'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationAdd(forwarding: true, locationName: camera_result_location.rawContent.toString(),))).then((value) => {
                                                          returnLocationName = value["returnLocationName"],
                                                          locationName = value["locationName"]
                                                        });
                                                        
                                                      },
                                                    ),
                                                  ]    
                                                  ));
                                        }         
                                        
                                      }
                                  },
                                ),
                                Positioned(
                                  right: 35, 
                                  child: IconButton(
                                  onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationAdd(forwarding: true,))).then((value) => {
                                    returnLocationName = value["returnLocationName"],
                                    locationName = value["locationName"]
                                  });},
                                  icon: Icon(Icons.add))),
                              ]
                            )
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        'Opis przedmiotu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    items: itemsDescription.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected = selectedItemsDescription.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                        ? selectedItemsDescription.remove(item)
                                                        : selectedItemsDescription.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                            ? const Icon(Icons.check_box_outlined)
                                                            : const Icon(Icons.check_box_outline_blank),
                                                    const SizedBox(width: 16),
                                                    Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    value: selectedItemsDescription.isEmpty ? null : selectedItemsDescription.last,
                                    onChanged: (value) {},
                                    iconSize: 0.0,
                                    buttonHeight: 50,
                                    // buttonWidth: 140,
                                    itemHeight: 40,
                                    dropdownMaxHeight: 200,
                                    itemPadding: EdgeInsets.zero,
                                    buttonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black26,
                                        ),
                                        color: Colors.grey[200],
                                        ),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                      ),
                                    selectedItemBuilder: (context) {
                                      return itemsDescription.map(
                                                (item) {
                                          return Container(
                                            alignment: AlignmentDirectional.center,
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: Text(
                                              selectedItemsDescription.join(', '),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                          );
                                        },
                                      ).toList();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // do something
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                      // title: const Text('Dodaj do opisu'),
                                      content: TextField(
                                                  controller: _textControllerAlertDialog,
                                                  autofocus: true,
                                                  decoration: const InputDecoration(
                                                        hintText: "Dodaj do opisu",
                                                        enabledBorder: UnderlineInputBorder(      
                                                          borderSide: BorderSide(color: Colors.green),   
                                                          ),  
                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.green),
                                                          ),  
                                                        ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.pink,
                                                      ),
                                                      child: Text('Anuluj',),
                                                      onPressed: () {
                                                        _textControllerAlertDialog.clear();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.green,
                                                      ),
                                                      child: Text('Dodaj'),
                                                      onPressed: () {
                                                        setState((){
                                                          //  _items.add(textController.text)  // 👈 add list item to the list
                                                          itemsDescription.add(_textControllerAlertDialog.text);
                                                          selectedItemsDescription.add(_textControllerAlertDialog.text);
                                                        });
                                                        print(selectedItemsDescription);
                                                        Navigator.pop(context, _textControllerAlertDialog.text);
                                                        _textControllerAlertDialog.clear();
                                                      },
                                                    ),
                                      ],
                                    ));
                                  },
                                ),
                                ]
                              ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SpinBox(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                readOnly: spinReadOnly,
                                enabled: spinEnabled,
                                min: 0,
                                max: 1000,
                                value: quantity,
                                onChanged: (value) => quantity=value,
                              )
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Text(
                                  'Wybierz stan przedmiotu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: deviceCondition.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              )).toList(),
                              value: selectedValueCondition,
                              onChanged: (value) {
                                setState(() {
                                  selectedValueCondition = value as String;
                                  });
                                },
                                buttonHeight: 50,
                                // buttonWidth: 200,
                                itemHeight: 40,
                                dropdownMaxHeight: 200,
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black26,
                                    ),
                                    color: Colors.grey[200],
                                    ),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  ),
                                // searchController: textEditingControllerCondition,
                                // searchInnerWidget: Padding(
                                // padding: const EdgeInsets.only(
                                //   top: 8,
                                //   bottom: 4,
                                //   right: 8,
                                //   left: 8,
                                // ),
                                // child: TextFormField(
                                //   controller: textEditingControllerStatus,
                                //   decoration: InputDecoration(
                                //   isDense: true,
                                //   contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 10,
                                //     vertical: 8,
                                //   ),
                                //   hintText: 'Wyszukaj status dla przedmiotu...',
                                //   hintStyle: const TextStyle(fontSize: 12),
                                //   border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(8),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // searchMatchFn: (item, searchValue) {
                                //   return (item.value.toString().contains(searchValue));
                                //   },
                                  //This to clear the search value when you close the menu
                                  // onMenuStateChange: (isOpen) {
                                  //   if (!isOpen) {
                                  //     textEditingControllerCondition.clear();
                                  //     }
                                  //     },
                                ))
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Text(
                                  'Wybierz status przedmiotu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: deviceStatus.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              )).toList(),
                              value: selectedValueStatus,
                              onChanged: (value) {
                                setState(() {
                                  selectedValueStatus = value as String;
                                  });
                                },
                                buttonHeight: 50,
                                // buttonWidth: 200,
                                itemHeight: 40,
                                dropdownMaxHeight: 130,
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black26,
                                    ),
                                    color: Colors.grey[200],
                                    ),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  ),
                                // searchController: textEditingControllerStatus,
                                // searchInnerWidget: Padding(
                                // padding: const EdgeInsets.only(
                                //   top: 8,
                                //   bottom: 4,
                                //   right: 8,
                                //   left: 8,
                                // ),
                                // child: TextFormField(
                                //   controller: textEditingControllerStatus,
                                //   decoration: InputDecoration(
                                //   isDense: true,
                                //   contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 10,
                                //     vertical: 8,
                                //   ),
                                //   hintText: 'Wyszukaj status dla przedmiotu...',
                                //   hintStyle: const TextStyle(fontSize: 12),
                                //   border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(8),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // searchMatchFn: (item, searchValue) {
                                //   return (item.value.toString().contains(searchValue));
                                //   },
                                  //This to clear the search value when you close the menu
                                  // onMenuStateChange: (isOpen) {
                                  //   if (!isOpen) {
                                  //     textEditingControllerStatus.clear();
                                  //     }
                                  //     },
                                ))
                          ),
                          SizedBox(height: 5),
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
                                    
                                    selectedItemsDescription.forEach((element) {
                                      if(selected_copy.containsKey(element)) {
                                        mapDescriptionToSave[element] = selected_copy[element];
                                      }
                                      else {
                                        mapDescriptionToSave[element] = false;
                                      }                             
                                      
                                    });
                                    mapDescriptionToSave = mapDescriptionToSave.map((key, value) => MapEntry('"$key"', value));
                                    
                                    if (_controllerSerialnumber.text.isEmpty || selectedValueEanDevice == null || selectedValueLocation == null || 
                                        selectedValueCondition == null || selectedValueStatus == null || _controllerID.text.isEmpty) {
                                          MotionToast.warning(
                                            title:  Text("UWAGA!"),
                                            description:  Text("Uzupełnij wszystkie wymagane pola.")
                                          ).show(context);
          
                                        }
                                    else {
                                    // Map mapDescription = {for (var item in selectedItemsDescription) '"$item"' : false};
                                    // print(mapDescriptionToSave);
                                    var ean_device_selected = selectedValueEanDevice.toString().split(" ");
                                    var ean_selected = ean_device_selected.last.substring(1, ean_device_selected.last.length - 1);;
                                    // print(ean_selected);
                                    EanDevice eanDevice = eanDevices.firstWhere((x) => x.ean == ean_selected.toString());
                                    Location location = locations.firstWhere((x) => x.name == selectedValueLocation.toString());
          
                                    Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerSerialnumber.text.toString());
                                    Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerID.text.toString());
          
                                    // if (device_sn != null) {
                                    //   MotionToast.error(
                                    //         title:  Text("BŁĄD!"),
                                    //         description:  Text("Istnieje urządzenie o podanym numerze seryjnym.")
                                    //       ).show(context);                          
                                    // } else if (device_qr != null){
                                    //   MotionToast.error(
                                    //         title:  Text("BŁĄD!"),
                                    //         description:  Text("Istnieje urządzenie o podanym ID.")
                                    //       ).show(context); 
                                    // }
                                    // else {
                                    Provider.of<DeviceProvider>(context, listen: false).editDevice(
                                      Device(
                                      deviceId: widget.deviceObject.deviceId,
                                      name: _controllerName.text.toString(),
                                      serialNumber: _controllerSerialnumber.text.toString(),
                                      // description: _controllerDescription.text.toString(),
                                      description: mapDescriptionToSave.toString(),
                                      eanDevice: eanDevice,
                                      location: location,
                                      quantity: quantity.toInt(),
                                      condition: selectedValueCondition.toString(),
                                      status: selectedValueStatus.toString(),
                                      dateAdded: "2023-01-01",
                                      qrCode: _controllerID.text.toString(),
                                      returned: widget.deviceObject.returned
                                      ));
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DevicePage()));
                                    // }
                                    }
                                  },
                            ),
                          ), 
                        ]),
                      ),
                    ),
                  )
                ),
                Container(
                  child: RefreshIndicator(
                    onRefresh: () async => {deviceHistoryProvider.getAllHistoryDevices(widget.deviceObject)},
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        Text(
                            'Liczba wpisów: ' + deviceHistory.length.toString(),
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
                          itemCount: deviceHistory.length,
                          itemBuilder: (context, index) {
                            final deviceHistoryItem = deviceHistory[index];
                            var date = DateFormat('d.M.yyyy HH:mm:ss').format(DateTime.parse(deviceHistoryItem.date));
                            return ListTile(
                                leading: const Icon(Icons.circle),
                                title: Text("[" + date + "]" + " " + deviceHistoryItem.event));
                          }
                        )
                      ]
                    )
                  )
                ),
              ]
            );    
            }
          ),
        ),
      ),
    );
  }


}