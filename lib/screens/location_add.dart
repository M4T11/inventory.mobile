import 'package:flutter/material.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/screens/device_add.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/services/location_services.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class LocationAdd extends StatefulWidget {
  final bool forwarding;

  const LocationAdd ({ Key? key, required this.forwarding}): super(key: key);

  
  
  @override
  State<LocationAdd> createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationService locationService = LocationService();
    // _controller.text = widget.categoryObject.name.toString();

    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        ),
        // backgroundColor: Colors.grey[300],
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // SizedBox(height: 25),
              Text(
                'Dodaj nową lokalizację',
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
                    controller: _controller,
                    textAlign: TextAlign.center,
                    // initialValue: widget.categoryObject.name.toString(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Wprowadź nazwę lokalizacji',
                    ),
                  ),
                ),
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
                        Provider.of<LocationProvider>(context, listen: false).addLocation(Location(
                          locationId: 0, 
                          name: _controller.text.toString()));
                          if (widget.forwarding) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage()));
                          }
                          
                      },
                ),
              ),
        
            ]),
          ),
        ),
      ),
    );
  }


}