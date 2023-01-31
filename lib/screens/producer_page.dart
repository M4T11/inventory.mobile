import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/producer_add.dart';
import 'package:inventoryapp/screens/producer_details.dart';
import 'package:inventoryapp/screens/producer_edit.dart';
import 'package:inventoryapp/services/producer_services.dart';
import 'package:provider/provider.dart';


class ProducerPage extends StatefulWidget {
  const ProducerPage({Key? key}) : super(key: key);

  @override
  State<ProducerPage> createState() => _ProducerPageState();
}

class _ProducerPageState extends State<ProducerPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Consumer<ProducerProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final producers = value.producers;
        return RefreshIndicator(
         onRefresh: () async => value.getAllProducers(),
         child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: producers.length,
          itemBuilder: (context, index) {
            final producer = producers[index];
            return GestureDetector(
              child: Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerEdit(producerObject: producer)));
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
                        value.deleteProducers(producer.producerId);
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
                    child: Text(producer.producerId.toString()),
                    // child: Text((index+1).toString()),
                    ),
                    title: Text(producer.name),
                    ),
              ),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProducerDetails(producerObject: producer)));
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
                MaterialPageRoute(builder: (context) => ProducerAdd(forwarding: false,)),
              );},
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}