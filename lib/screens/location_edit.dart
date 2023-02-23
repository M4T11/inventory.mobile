import 'package:flutter/material.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/services/location_services.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:collection/collection.dart'; 

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      
    });
  }

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

    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        ),
        // backgroundColor: Colors.grey[300],
        backgroundColor: Colors.white,
        body: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            if(locationProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
                );
            }
          final locations = locationProvider.locations;
          return SafeArea(
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
                      Location? location = locations.firstWhereOrNull((x) => x.name == _controller.text.toString());
                      if (_controller.text.isEmpty) {
                        MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Uzupełnij wszystkie wymagane pola.")
                                    ).show(context);
                      } else if (location != null) {
                        MotionToast.error(
                                      title:  Text("BŁĄD!"),
                                      description:  Text("Istnieje już lokalizacja o wprowadzonej nazwie.")
                                    ).show(context);
                       
                      } else {
                          Provider.of<LocationProvider>(context, listen: false).editLocations(Location(
                            locationId: widget.locationObject.locationId, 
                            name: _controller.text.toString()));
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage())).then((value) => _controller.clear());
                        }
                    }
                  ),
                ),
          
              ]),
            ),
          );
          }
        ),
      ),
    );
  }


}