import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:inventoryapp/screens/category_add.dart';
import 'package:inventoryapp/screens/category_details.dart';
import 'package:inventoryapp/screens/category_edit.dart';
import 'package:inventoryapp/services/category_services.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:motion_toast/motion_toast.dart'; 


class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
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
      body: Consumer2<CategoryProvider, DeviceProvider>(
        builder: (context, categoryProvider, deviceProvider, child) {
          if(categoryProvider.isLoading || deviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final categories = categoryProvider.categories;
        final devices = deviceProvider.devices;
        return RefreshIndicator(
         onRefresh: () async => categoryProvider.getAllCategories(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryEdit(categoryObject: category)));
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
                        Device? device = devices.firstWhereOrNull((x) => x.eanDevice.category.name == category.name);
                        if(device != null) {
                          MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Nie można usunąć kategorii powiązanej z urządzeniami.")
                                    ).show(context);

                        } else {
                        categoryProvider.deleteCategories(category.categoryId);
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
                    // child: Text(category.categoryId.toString()),
                    child: Text((index+1).toString()),
                    ),
                    title: Text(category.name),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryDetails(categoryObject: category)),);
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
                MaterialPageRoute(builder: (context) => CategoryAdd(forwarding: false,)),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}