import 'package:flutter/material.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/services/location_services.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:provider/provider.dart';

class LocationEdit extends StatefulWidget {
  final Location locationObject;
  // const CategoryEdit({Key? key}) : super(key: key);
  // const CategoryEdit({super.key, required this.category});
  const LocationEdit ({ Key? key, required this.locationObject}): super(key: key);
  


  @override
  State<LocationEdit> createState() => _LocationEditState();
}

class _LocationEditState extends State<LocationEdit> {
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
    _controller.text = widget.locationObject.name.toString();

    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      // backgroundColor: Colors.grey[300],
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // SizedBox(height: 25),
            Text(
              'Edytuj lokalizację',
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
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    print(widget.locationObject.locationId.toString());
                    print(_controller.text.toString());
                    // categoryService.editCategory(Category(
                    //   categoryId: widget.categoryObject.categoryId, 
                    //   name: _controller.text.toString()));
                    Provider.of<LocationProvider>(context, listen: false).editLocations(Location(
                      locationId: widget.locationObject.locationId, 
                      name: _controller.text.toString()));
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage()));
                  },
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
              ),
            ),
      
          ]),
        ),
      ),
    );
  }


}