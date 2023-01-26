import 'package:flutter/material.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/screens/producer_page.dart';
import 'package:inventoryapp/services/producer_services.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:provider/provider.dart';

class ProducerAdd extends StatefulWidget {
  // final Category categoryObject;
  const ProducerAdd({Key? key}) : super(key: key);
  // const CategoryEdit({super.key, required this.category});
  // const CategoryAdd ({ Key? key, required this.categoryObject}): super(key: key);
  


  @override
  State<ProducerAdd> createState() => _ProducerAddState();
}

class _ProducerAddState extends State<ProducerAdd> {
  TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProducerService producerService = ProducerService();
    // _controller.text = widget.categoryObject.name.toString();

    return Scaffold(
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
              'Dodaj nowego producenta',
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
                    hintText: 'Wprowadź nazwę producenta',
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
                      Provider.of<ProducerProvider>(context, listen: false).addProducer(Producer(
                        producerId: 0, 
                        name: _controller.text.toString()));
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerPage()));
                    },
              ),
            ),
      
          ]),
        ),
      ),
    );
  }


}