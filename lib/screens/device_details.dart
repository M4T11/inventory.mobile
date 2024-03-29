import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/models/device_history_model.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/provider/device_history_provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:inventoryapp/screens/device_edit.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_spinbox/material.dart';
import 'dart:convert';
import 'package:quiver/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class DeviceDetails extends StatefulWidget {
  final Device deviceObject;
  const DeviceDetails({ Key? key, required this.deviceObject}): super(key: key);
  
  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> with SingleTickerProviderStateMixin{

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

  List<String> deviceCondition = ["Nowe", "Używane"]; 
  List<String> deviceStatus = ["Do naprawy", "Do wystawienia", "Wystawione", "Do zdjęć", "Na części", "Sprzedane"]; 
    
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      Provider.of<DeviceHistoryProvider>(context, listen: false).getAllHistoryDevices(widget.deviceObject);
    });
    if(widget.deviceObject.returned) {
      _enabled = false;
    } else {
      _enabled = true;
    }
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        if(_tabController.index ==1) {
          Provider.of<DeviceHistoryProvider>(context, listen: false).getAllHistoryDevices(widget.deviceObject);
        }        
      });
    });
    

    newDevice = widget.deviceObject;
    selectedValueEanDevice= widget.deviceObject.eanDevice.producer.name + " " + widget.deviceObject.eanDevice.model + " (" + widget.deviceObject.eanDevice.ean + ")";
    selectedValueLocation = widget.deviceObject.location.name;
    selectedValueStatus = widget.deviceObject.status;
    selectedValueCondition = widget.deviceObject.condition;
    quantity = widget.deviceObject.quantity.toDouble();
    _controllerSerialnumber.text = widget.deviceObject.serialNumber.toString();
    _controllerName.text = widget.deviceObject.name.toString();
    // _controllerDescription.text = widget.deviceObject.description.toString();
    _controllerID.text = widget.deviceObject.qrCode.toString();

    Map selected = json.decode(widget.deviceObject.description);

    selected.keys.forEach((key) {
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

  void _onTap () {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
      title: const Text('UWAGA'),
      content: const Text('Czy chcesz zarejestrować zwrot produktu?'),
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
        child: Text('Zarejestruj zwrot'),
        onPressed: () {
          setState(() => _enabled = false);
          int new_quantity = widget.deviceObject.quantity.toInt() + 1;
          String new_name = "[ZWROT] " + widget.deviceObject.name;

          newDevice = Device(
            deviceId: widget.deviceObject.deviceId,
            name: new_name,
            serialNumber: widget.deviceObject.serialNumber,
            description: widget.deviceObject.description,
            eanDevice: widget.deviceObject.eanDevice,
            location: widget.deviceObject.location,
            quantity: new_quantity,
            condition: widget.deviceObject.condition.toString(),
            status: widget.deviceObject.status.toString(),
            dateAdded: "2023-01-01",
            qrCode: widget.deviceObject.qrCode.toString(),
            returned: true
            );
          setState(() {
            quantity = newDevice.quantity.toDouble();
            _controllerName.text = newDevice.name;   
          });
          Provider.of<DeviceProvider>(context, listen: false).editDevice(newDevice);
          Navigator.pop(context);
          MotionToast.success(
                      title:  Text("SUKCES!"),
                      description:  Text("Zarejestrowano zwrot dla produktu.")
                    ).show(context);
          
                  
        },
      ),
    ]    
    ));
  }

  TextEditingController _controllerSerialnumber = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  // TextEditingController _controllerDescription = new TextEditingController();
  TextEditingController _controllerID = new TextEditingController();

  late TabController _tabController;
  late bool _enabled;
  late Device newDevice;
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
    // _controllerDescription.dispose();
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
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Szczegóły",
              ),
              new Tab(
                text: "Historia",
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: Consumer3<EanDeviceProvider, LocationProvider, DeviceHistoryProvider>(
          builder: (context, eanDeviceProvider, locationProvider, deviceHistoryProvider, child) {
            if(eanDeviceProvider.isLoading || locationProvider.isLoading || deviceHistoryProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
                );
            }
            final eanDevices = eanDeviceProvider.eanDevices;
            final locations = locationProvider.locations;
            final deviceHistory = deviceHistoryProvider.historyDevices;
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
                          //   'Szczegóły urządzenia',
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
                                style: TextStyle(color: Colors.grey),
                                enabled: false,
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
                                      style: TextStyle(color: Colors.grey),
                                      enabled: false,
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
                                  onPressed: null,
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
                                          style: TextStyle(color: Colors.grey),
                                          controller: _controllerID,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Nadaj unikalne ID',
                                          ),
                                        ),
                                      ),
                                    IconButton(
                                      icon: Icon(Icons.camera_alt_rounded),
                                      onPressed: null,
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
                          //       enabled: false,
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
                                onChanged: null,
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
                                  onPressed: null,
                                ),
                                Positioned(
                                  right: 35, 
                                  child: IconButton(
                                    onPressed: null, 
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
                                onChanged: null,
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
                                      onPressed: null,
                                    ),
                                    Positioned(
                                      right: 35, 
                                      child: IconButton(
                                      onPressed: null, 
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
                                        onChanged: null,
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
                                      onPressed: null
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
                                    textStyle: TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                    min: 1,
                                    max: 1000,
                                    value: quantity,
                                    onChanged: null,
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
                              onChanged: null,
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
                                searchController: textEditingControllerCondition,
                                searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
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
                                ),
                                // searchMatchFn: (item, searchValue) {
                                //   return (item.value.toString().contains(searchValue));
                                //   },
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingControllerCondition.clear();
                                      }
                                      },
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
                              onChanged: null,
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
                                searchController: textEditingControllerStatus,
                                searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  controller: textEditingControllerStatus,
                                  decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Wyszukaj status dla przedmiotu...',
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
                                      textEditingControllerStatus.clear();
                                      }
                                      },
                                ))
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 
                            [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edytuj',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,                          
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceEdit(deviceObject: newDevice)));
                                  },
                                ),
                              ),
                              SizedBox(width: 5,),
                              Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: _enabled ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Zwrot',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,                        
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: _enabled ? _onTap: null,
                              ),
                            ),
                            ]
                          ),
                              
                        ]),
                      ),
                    ),
                  ),
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
                            var date = DateFormat('d.MM.yyyy HH:mm:ss').format(DateTime.parse(deviceHistoryItem.date));
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
    );
  }


}