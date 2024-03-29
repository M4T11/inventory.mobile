import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/models/location_model.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/provider/location_provider.dart';
import 'package:inventoryapp/screens/location_add.dart';
import 'package:inventoryapp/screens/location_details.dart';
import 'package:inventoryapp/screens/location_edit.dart';
import 'package:inventoryapp/services/location_services.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LocationProvider>(context, listen: false).getAllLocations();
      Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Consumer2<LocationProvider, DeviceProvider>(
        builder: (context, locationProvider, deviceProvider, child) {
          if(locationProvider.isLoading || deviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final locations = locationProvider.locations;
        final devices = deviceProvider.devices;
        return RefreshIndicator(
         onRefresh: () async => locationProvider.getAllLocations(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationEdit(locationObject: location)));
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
                        Device? device = devices.firstWhereOrNull((x) => x.location.name == location.name);
                        if(device != null) {
                          MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Nie można usunąć lokalizacji powiązanej z urządzeniami.")
                                    ).show(context);

                        } else {
                        locationProvider.deleteLocations(location.locationId);
                        }                 
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
                    // child: Text(location.locationId.toString()),
                    child: Text((index+1).toString()),
                    ),
                    title: Text(location.name),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationDetails(locationObject: location)),);
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
                MaterialPageRoute(builder: (context) => LocationAdd(forwarding: false,)),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}