import 'package:flutter/material.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/ean_device_edit.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class EanDeviceDetails extends StatefulWidget {
  final EanDevice eanDeviceObject;
  // const EanDeviceEdit({Key? key}) : super(key: key);
  const EanDeviceDetails ({ Key? key, required this.eanDeviceObject}): super(key: key);
  
  @override
  State<EanDeviceDetails> createState() => _EanDeviceDetailsState();
}

class _EanDeviceDetailsState extends State<EanDeviceDetails> {


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
    });
    selectedValueCategory = widget.eanDeviceObject.category.name;
    selectedValueProducer = widget.eanDeviceObject.producer.name;
    _controllerEAN.text = widget.eanDeviceObject.ean.toString();
    _controllerModel.text = widget.eanDeviceObject.model.toString();
    
  }

  
  String? selectedValueCategory;
  final TextEditingController textEditingControllerCategory = TextEditingController();
  String? selectedValueProducer;
  final TextEditingController textEditingControllerProducer = TextEditingController();
  final TextEditingController _controllerModel = TextEditingController();
  final TextEditingController _controllerEAN =  TextEditingController();
  
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
    // _controller.text = widget.categoryObject.name.toString();

    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      // backgroundColor: Colors.grey[300],
      // backgroundColor: Colors.white,
      body: Consumer2<CategoryProvider, ProducerProvider>(
        builder: (context, categoryProvider, producerProvider, child) {
          if(categoryProvider.isLoading || producerProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
          final categories = categoryProvider.categories;
          final producers = producerProvider.producers;
          return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // SizedBox(height: 25),
              Text(
                'Szczegóły urządzenia EAN',
                // widget.categoryObject.categoryId.toString() + widget.categoryObject.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          enabled: false,
                          controller: _controllerEAN,
                          textAlign: TextAlign.center,
                          // initialValue: widget.categoryObject.name.toString(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Wprowadź nr EAN przedmiotu',
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(Icons.camera_alt_rounded),
                      onPressed: () {
                        // do something
                      },
                    ),
                  ],
                ),             
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Text(
                      'Wybierz kategorię przedmiotu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: categories.map((item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )).toList(),
                  value: selectedValueCategory,
                  onChanged: null,
                    buttonHeight: 50,
                    // buttonWidth: 200,
                    itemHeight: 40,
                    dropdownMaxHeight: 200,
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black26,
                        ),
                        color: Colors.grey[200],
                        ),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                      ),
                    searchController: textEditingControllerCategory,
                    searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: textEditingControllerCategory,
                      decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Wyszukaj kategorię...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // searchMatchFn: (item, searchValue) {
                    //   return (item.value.toString().contains(searchValue));
                    //   },
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingControllerCategory.clear();
                          }
                          },
                    ))
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Text(
                      'Wybierz producenta przedmiotu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: producers.map((item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )).toList(),
                  value: selectedValueProducer,
                  onChanged: null,
                    buttonHeight: 50,
                    // buttonWidth: 200,
                    itemHeight: 40,
                    dropdownMaxHeight: 200,
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black26,
                        ),
                        color: Colors.grey[200],
                        ),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                      ),
                    searchController: textEditingControllerProducer,
                    searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: textEditingControllerProducer,
                      decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Wyszukaj producenta...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // searchMatchFn: (item, searchValue) {
                    //   return (item.value.toString().contains(searchValue));
                    //   },
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingControllerProducer.clear();
                          }
                          },
                    ))
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
                    enabled: false,
                    controller: _controllerModel,
                    textAlign: TextAlign.center,
                    // initialValue: widget.categoryObject.name.toString(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Wprowadź model przedmiotu',
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
                        'Edytuj',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDeviceEdit(eanDeviceObject: widget.eanDeviceObject)));
                      },
                ),
              ),
        
            ]),
          ),
        );
        }
      ),
    );
  }


}