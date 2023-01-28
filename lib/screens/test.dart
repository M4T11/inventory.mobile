import 'package:flutter/material.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:barcode_scan2/barcode_scan2.dart';


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  List<String> categories = ["Nowe", "Używane", "Do naprawy", "Do zdjęć", "Do wystawienia", "Na części"]; 
  List<String> producers = ["Nowe", "Używane", "Do naprawy", "Do zdjęć", "Do wystawienia", "Na części"]; 


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
    });
    
  }

  TextEditingController _controllerEAN = new TextEditingController();
  String? selectedValueCategory;
  final TextEditingController textEditingControllerCategory = TextEditingController();
  String? selectedValueProducer;
  final TextEditingController textEditingControllerProducer = TextEditingController();
  TextEditingController _controllerModel = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerEAN.dispose();
    textEditingControllerCategory.dispose();
    textEditingControllerProducer.dispose();
    _controllerModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: SingleChildScrollView(
        child: Column(  
            children: [
              Container(
                width: double.infinity,
                height: 700,
                color: Colors.orange,
              ),
              const TextField(
                decoration: InputDecoration(labelText: "Type something"),
              )
            ]),
      ),
    );
  }
}