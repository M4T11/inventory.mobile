import 'package:flutter/material.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/models/ean_device_model.dart';
import 'package:inventoryapp/models/producer_model.dart';
import 'package:inventoryapp/provider/ean_device_provider.dart';
import 'package:inventoryapp/provider/producer_provider.dart';
import 'package:inventoryapp/screens/category_add.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:inventoryapp/screens/producer_add.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:motion_toast/motion_toast.dart'; 
import 'package:collection/collection.dart';


class EanDeviceAdd extends StatefulWidget {
  final bool forwarding;
  final String? eanCode;

  const EanDeviceAdd ({ Key? key, required this.forwarding, this.eanCode}): super(key: key);
  
  @override
  State<EanDeviceAdd> createState() => _EanDeviceAddState();
}

class _EanDeviceAddState extends State<EanDeviceAdd> {


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      Provider.of<ProducerProvider>(context, listen: false).getAllProducers();
      Provider.of<EanDeviceProvider>(context, listen: false).getAllEanDevices();
      
    });

    if(widget.eanCode != null) {
      _controllerEAN.text = widget.eanCode.toString();
    }
    returnCategory = false;
    returnProducer = false;
    
  }

  void setProducer(List<Producer> list, String producerName) {
    Producer producer = list.firstWhere((x) => x.name == producerName);
    selectedValueProducer = producer.name;
  }

    void setCategory(List<Category> list, String categoryName) {
    Category category = list.firstWhere((x) => x.name == categoryName);
    selectedValueCategory = category.name;
  }

  late String producerName;
  late bool returnProducer;
  late String categoryName;
  late bool returnCategory;

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

    // _controller.text = widget.categoryObject.name.toString();
    
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        ),
        // backgroundColor: Colors.grey[300],
        // backgroundColor: Colors.white,
        body: Consumer3<CategoryProvider, ProducerProvider, EanDeviceProvider>(
          builder: (context, categoryProvider, producerProvider, eanDeviceProvider, child) {
            if(categoryProvider.isLoading || producerProvider.isLoading || eanDeviceProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
                );
            }
            final categories = categoryProvider.categories;
            final producers = producerProvider.producers;
            final eanDevices = eanDeviceProvider.eanDevices;

            if(returnCategory) {
              setCategory(categories, categoryName);
              returnCategory = false;
            }
            if(returnProducer) {
              setProducer(producers, producerName);
              returnProducer = false;
            }

            return SafeArea(
            child: Center(
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // SizedBox(height: 25),
                    Text(
                      'Dodaj nowe urządzenie EAN',
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
                            onPressed: () async {
                              var result = await BarcodeScanner.scan();
                              print(result.type); // The result type (barcode, cancelled, failed)
                              print(result.rawContent); // The barcode content
                              print(result.format); // The barcode format (as enum)
                              print(result.formatNote); // If a unknown format was sc
                              
                              if(result.format != 'unknown' && result.type != 'Cancelled' && result.rawContent.isNotEmpty) {
                                _controllerEAN.text = result.rawContent.toString();
                              }
                            },
                          ),
                        ],
                      ),
                      
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                        DropdownButtonHideUnderline(
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
                          onChanged: (value) {
                            setState(() {
                              selectedValueCategory = value as String;
                              });
                            },
                            iconSize: 0.0,
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
                            )),
                            IconButton(
                              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryAdd(forwarding: true,))).then((value) => {
                                returnCategory = value["returnCategory"],
                                categoryName = value["categoryName"]
                              });}, 
                              icon: Icon(Icons.add)),
                        ]
                      )
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                        DropdownButtonHideUnderline(
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
                          onChanged: (value) {
                            setState(() {
                              selectedValueProducer = value as String;
                              });
                            },
                            iconSize: 0.0,
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
                            )),
                            IconButton(
                              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerAdd(forwarding: true,))).then((value) => {
                                returnProducer = value["returnProducer"],
                                producerName = value["producerName"]
                              });}, 
                              icon: Icon(Icons.add)),
                        ]
                      )
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
                          if (selectedValueCategory == null || selectedValueProducer == null || _controllerEAN.text.isEmpty || _controllerModel.text.isEmpty) {
                                MotionToast.warning(
                                              title:  Text("UWAGA!"),
                                              description:  Text("Uzupełnij wszystkie wymagane pola.")
                                            ).show(context);
                                
                          } else {
                              Category category = categories.firstWhere((x) => x.name == selectedValueCategory.toString());
                              Producer producer = producers.firstWhere((x) => x.name == selectedValueProducer.toString());

                              EanDevice? ean_device = eanDevices.firstWhereOrNull((x) => x.ean == _controllerEAN.text.toString());
                              EanDevice? ean_device_model = eanDevices.firstWhereOrNull((x) => x.model == _controllerModel.text.toString());
                            

                              if (ean_device != null) {
                                MotionToast.error(
                                      title:  Text("BŁĄD!"),
                                      description:  Text("Istnieje urządzenie o podanym numerze EAN.")
                                    ).show(context);
                              } else if (ean_device_model != null) {
                                MotionToast.error(
                                      title:  Text("BŁĄD!"),
                                      description:  Text("Istnieje urządzenie o podanym modelu.")
                                    ).show(context);
                              }
                              else {
                                Provider.of<EanDeviceProvider>(context, listen: false).addEanDevice(
                                  EanDevice(
                                  eanDeviceId: 0,
                                  ean: _controllerEAN.text.toString(),
                                  category: category,
                                  producer: producer,
                                  // category: Category(categoryId: 0, name: selectedValueCategory.toString()),
                                  // producer: Producer(producerId: 0, name: selectedValueProducer.toString()),
                                  model: _controllerModel.text.toString()));
                                  if (widget.forwarding) {
                                    final data = { "returnEAN" : true, "ean" : _controllerEAN.text.toString() };
                                    Navigator.of(context).pop(data);
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDevicePage()));
                                  }
                             } 
                          }                               
                        },
                      ),
                    ),
                        
                  ]),
                )
            ),
          );
          }
        ),
      ),
    );
  }
}