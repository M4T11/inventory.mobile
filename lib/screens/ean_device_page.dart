import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/screens/location_add.dart';
import 'package:inventoryapp/screens/location_edit.dart';
import 'package:inventoryapp/services/ean_device_services.dart';
import 'package:provider/provider.dart';


class EanDevicePage extends StatefulWidget {
  const EanDevicePage({Key? key}) : super(key: key);

  @override
  State<EanDevicePage> createState() => _EanDevicePageState();
}

class _EanDevicePageState extends State<EanDevicePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Consumer<EanDeviceProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final eanDevices = value.eanDevices;
        return RefreshIndicator(
         onRefresh: () async => value.getAllEanDevices(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: eanDevices.length,
          itemBuilder: (context, index) {
            final eanDevice = eanDevices[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: ((context) {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationEdit(locationObject: eanDevice)));
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
                      value.deleteLocations(eanDevice.eanDeviceId);
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
                  child: Text(eanDevice.eanDeviceId.toString()),
                  // child: Text((index+1).toString()),
                  ),
                  title: Text(eanDevice.producer.name + " " + eanDevice.model),
                  ),
            );
          }),
          );   
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationAdd()),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}