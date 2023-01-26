import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:inventoryapp/screens/device_edit.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class DeviceDetails extends StatefulWidget {
  final Device deviceObject;
  const DeviceDetails ({ Key? key, required this.deviceObject}): super(key: key);
  
  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {

  List<String> deviceStatus = ["Nowe", "Używane", "Do naprawy", "Do zdjęć", "Do wystawienia", "Na części"]; 

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
    });
    selectedValueEanDevice= widget.deviceObject.eanDevice.producer.name + " " + widget.deviceObject.eanDevice.model + " (" + widget.deviceObject.eanDevice.ean + ")";
    selectedValueLocation = widget.deviceObject.location.name;
    selectedValueStatus = widget.deviceObject.status;
    _controllerSerialnumber.text = widget.deviceObject.serialNumber.toString();
    _controllerName.text = widget.deviceObject.name.toString();
    _controllerDescription.text = widget.deviceObject.description.toString(); 
    
  }

  TextEditingController _controllerSerialnumber = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerDescription = new TextEditingController();

  String? selectedValueEanDevice;
  final TextEditingController textEditingControllerEanDevice = TextEditingController();
  String? selectedValueLocation;
  final TextEditingController textEditingControllerLocation = TextEditingController();
  String? selectedValueStatus;
  final TextEditingController textEditingControllerStatus = TextEditingController();
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerSerialnumber.dispose();
    _controllerName.dispose();
    _controllerDescription.dispose();
    textEditingControllerEanDevice.dispose();
    textEditingControllerLocation.dispose();
    textEditingControllerStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // _controller.text = widget.categoryObject.name.toString();

    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      // backgroundColor: Colors.grey[300],
      // backgroundColor: Colors.white,
      body: Consumer2<EanDeviceProvider, LocationProvider>(
        builder: (context, eanDeviceProvider, locationProvider, child) {
          if(eanDeviceProvider.isLoading || locationProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
          final eanDevices = eanDeviceProvider.eanDevices;
          final locations = locationProvider.locations;
          return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // SizedBox(height: 25),
              Text(
                'Szczegóły urządzenia',
                // widget.categoryObject.categoryId.toString() + widget.categoryObject.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
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
              SizedBox(height: 25),
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
                      onPressed: () {
                        // do something
                      },
                    ),
                  ],
                ),               
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    enabled: false,
                    controller: _controllerDescription,
                    textAlign: TextAlign.center,
                    // initialValue: widget.categoryObject.name.toString(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Wprowadź opis przedmiotu (opcjonalne)',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
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
                      onPressed: () {
                        // do something
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonHideUnderline(
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
                    ))
              ),
              SizedBox(height: 25),
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceEdit(deviceObject: widget.deviceObject)));
                      },
                ),
              ),
        
            ]),
          ),
        );
        }
      ),
    );
  }


}