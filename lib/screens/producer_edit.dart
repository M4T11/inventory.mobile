import 'package:flutter/material.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/screens/producer_page.dart';
import 'package:inventoryapp/services/producer_services.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ProducerEdit extends StatefulWidget {
  final Producer producerObject;
  // const CategoryEdit({Key? key}) : super(key: key);
  // const CategoryEdit({super.key, required this.category});
  const ProducerEdit ({ Key? key, required this.producerObject}): super(key: key);
  


  @override
  State<ProducerEdit> createState() => _ProducerEditState();
}

class _ProducerEditState extends State<ProducerEdit> {
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
    _controller.text = widget.producerObject.name.toString();

    return KeyboardDismisser(
      child: Scaffold(
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
                'Edytuj producenta',
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
                        Provider.of<ProducerProvider>(context, listen: false).editProducers(Producer(
                          producerId: widget.producerObject.producerId, 
                          name: _controller.text.toString()));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerPage()));
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