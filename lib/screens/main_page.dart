import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/screens/category_page.dart';
import 'package:inventoryapp/screens/device_add.dart';
import 'package:inventoryapp/screens/device_details.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:inventoryapp/screens/device_page_model.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/screens/producer_page.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:inventoryapp/screens/repair_page.dart';
import 'package:provider/provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    final TextEditingController _controllerSearch =  TextEditingController();
    final TextEditingController _controllerSearchAll =  TextEditingController();
    final TextEditingController _controllerRepair =  TextEditingController();

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<DeviceProvider>(context, listen: false).getAlldevices();
      });
      
    }

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      _controllerSearch.dispose();
      _controllerRepair.dispose();
      _controllerSearchAll.dispose();
      super.dispose();
    }

    final List<String> items = [
      'Urządzenie',
      'Wszystkie egzemplarze',
      'Zawartość miejsca',
    ];

    String? selectedValueSearchType = 'Urządzenie';

    List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
      List<DropdownMenuItem<String>> _menuItems = [];
      for (var item in items) {
        _menuItems.addAll(
          [
            DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            //If it's last item, we will not add Divider after it.
            if (item != items.last)
              const DropdownMenuItem<String>(
                enabled: false,
                child: Divider(),
              ),
          ],
        );
      }
      return _menuItems;
    }

    List<double> _getCustomItemsHeights() {
      List<double> _itemsHeights = [];
      for (var i = 0; i < (items.length * 2) - 1; i++) {
        if (i.isEven) {
          _itemsHeights.add(40);
        }
        //Dividers indexes will be the odd indexes
        if (i.isOdd) {
          _itemsHeights.add(4);
        }
      }
      return _itemsHeights;
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, value, child) {
          if(value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
              );
          }
        final devices = value.devices;
        return RefreshIndicator(
         onRefresh: () async => value.getAlldevices(),
         child:SafeArea(
          child: Center(
            child: SingleChildScrollView(
              // reverse: true,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: (1 / 0.5),
                    crossAxisCount: 1,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      // DODAJ
                        Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          ),
                        elevation: 1.0,
                        margin: EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff73c088),
                            borderRadius: BorderRadius.circular(12),
                            ),
                          child: InkWell(
                            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceAdd()));},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              verticalDirection: VerticalDirection.down,
                              children: <Widget>[
                                SizedBox(height: 50.0),
                                Center(
                                  child: Text("DODAJ URZĄDZENIE",
                                  style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)))                                       
                                ),
                                SizedBox(height: 20.0),
                                Center(
                                    child: Icon(
                                  Icons.add_box_rounded,
                                  size: 40.0,
                                  color: Colors.white,
                                )),
                                
                              ],
                            ),
                          ),
                        )),
                      // WYSZUKAJ
                      FlipCard(
                        fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL, // default
                        side: CardSide.FRONT, // The side to initially display.
                        front: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Column (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(height: 50.0),
                            Center(
                              child: Text('WYSZUKAJ PRZEDMIOT',
                              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold))),
                              // TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.montserrat())),
                            ),                        
                            SizedBox(height: 20.0),
                            Center(
                                child: Icon(
                              Icons.search_rounded,
                              size: 40.0,
                              color: Colors.white,
                            )),
                            
                            ],
                          ),
                        ),
                        back: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Container(
                                    width: 300,
                                    height: 60,
                                    padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextField(
                                        textInputAction: TextInputAction.search,
                                        onSubmitted: (value) {
                                          Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerSearch.text.toString());
                                          Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerSearch.text.toString());
                            
                                          if (device_sn == null && device_qr == null) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                              title: const Text('UWAGA'),
                                              content: const Text('Nie znaleziono urządzenia'),
                                              actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.pink,
                                                ),
                                                child: Text('Anuluj',),
                                                onPressed: () {
                                                  _controllerSearch.clear();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.green,
                                                ),
                                                child: Text('Dodaj'),
                                                onPressed: () {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceAdd()));
                                                  
                                                },
                                              ),
                                            ]    
                                            ));
                                            
                                          } else {
                                            if (device_qr != null) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceDetails(deviceObject: device_qr)));
                                            } 
                                            if (device_sn != null) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceDetails(deviceObject: device_sn)));
                            
                                            }
                                            
                                          }
                                          _controllerSearch.clear();
                            
                                        },
                                        controller: _controllerSearch,
                                        textAlign: TextAlign.center,
                                        // initialValue: widget.categoryObject.name.toString(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Wprowadź SN lub kod QR przedmiotu',
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
                                          _controllerSearch.text = result.rawContent.toString();
                                          Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerSearch.text.toString());
                                          Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerSearch.text.toString());
                            
                                          if (device_sn == null && device_qr == null) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                              title: const Text('UWAGA'),
                                              content: const Text('Nie znaleziono urządzenia'),
                                              actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.pink,
                                                ),
                                                child: Text('Anuluj',),
                                                onPressed: () {
                                                  _controllerSearch.clear();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.green,
                                                ),
                                                child: Text('Dodaj'),
                                                onPressed: () {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceAdd()));
                                                  
                                                },
                                              ),
                                            ]    
                                            ));
                                            
                                          } else {
                                            if (device_qr != null) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceDetails(deviceObject: device_qr)));
                                            } 
                                            if (device_sn != null) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceDetails(deviceObject: device_sn)));
                            
                                            }
                                            
                                          }
                                          _controllerSearch.clear();
                                        }
                                        
                                      },
                                  ),
                            
                                ],
                              ),
                              SizedBox(height: 10,),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  // hint: Text(
                                  //   'Select Item',
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     color: Theme.of(context).hintColor,
                                  //   ),
                                  // ),
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
                                  items: _addDividersAfterItems(items),
                                  customItemsHeights: _getCustomItemsHeights(),
                                  value: selectedValueSearchType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValueSearchType = value as String;
                                    });
                                  },
                                  buttonHeight: 40,
                                  dropdownMaxHeight: 200,
                                  buttonWidth: 300,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                )),
                              ]
                            ),
                          ),
                        ),
                      ),
                      // ZNAJDZ WSZYSTKIE
                        FlipCard(
                        fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL, // default
                        side: CardSide.FRONT, // The side to initially display.
                        front: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Column (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(height: 50.0),
                            Center(
                              child: Text('ZNAJDŹ WSZYSTKIE',
                              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold))),
                              // TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.montserrat())),
                            ),
                            SizedBox(height: 20.0),
                            Center(
                                child: Icon(
                              Icons.search_rounded,
                              size: 40.0,
                              color: Colors.white,
                            )),
                            
                            ],
                          ),
                        ),
                        back: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Container(
                                    width: 300,
                                    height: 60,
                                    padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextField(
                                        controller: _controllerSearchAll,
                                        textInputAction: TextInputAction.search,
                                        onSubmitted: (value) {
                                          // print(_controllerSearchAll.text.toString());
                                          Device? device_search_all = devices.firstWhereOrNull((x) => x.eanDevice.ean == _controllerSearchAll.text.toString());
                                          // Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerSearchAll.text.toString());
                                          // print(device_search_all);
                                          if (device_search_all == null) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                              title: const Text('UWAGA'),
                                              content: const Text('Nie znaleziono w magazynie urządzeń o podanym numerze EAN'),
                                              actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.pink,
                                                ),
                                                child: Text('OK',),
                                                onPressed: () {
                                                  _controllerSearchAll.clear();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ]    
                                            ));
                                            
                                          } else {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DevicePageModel(deviceEAN: _controllerSearchAll.text))).then((value) => _controllerSearchAll.clear());
                                            // _controllerSearchAll.clear();
                                               
                                          }
                            
                                        },
                                        textAlign: TextAlign.center,
                                        // initialValue: widget.categoryObject.name.toString(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Wprowadź EAN przedmiotu',
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
                                          // _controllerSearchAll.text = result.rawContent.toString();
                                          Device? device_search_all = devices.firstWhereOrNull((x) => x.eanDevice.ean == _controllerSearchAll.text.toString());
                                          // Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerSearchAll.text.toString());
                                          // print(device_search_all);
                                          if (device_search_all == null) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                              title: const Text('UWAGA'),
                                              content: const Text('Nie znaleziono w magazynie urządzeń o podanym numerze EAN'),
                                              actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.pink,
                                                ),
                                                child: Text('OK',),
                                                onPressed: () {
                                                  _controllerSearchAll.clear();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ]    
                                            ));
                                            
                                          } else {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DevicePageModel(deviceEAN: _controllerSearchAll.text))).then((value) => _controllerSearchAll.clear());
                                              
                                          }
                                        }
                                        
                                      },
                                    
                                  ),
                                  
                                ],
                              ),
                              ]
                            ),
                          ),
                        ),
                      ),
                      // NAPRAWA
                        FlipCard(
                        fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL, // default
                        side: CardSide.FRONT, // The side to initially display.
                        front: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Column (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(height: 50.0),
                            Center(
                              child: Text('NAPRAW PRZEDMIOT',
                              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold))),
                              // TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.montserrat())),
                            ),
                            SizedBox(height: 20.0),
                            Center(
                                child: Icon(
                              Icons.home_repair_service_rounded,
                              size: 40.0,
                              color: Colors.white,
                            )),
                            
                            ],
                          ),
                        ),
                        back: Container(
                            margin: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff73c088),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  height: 60,
                                  padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (value) {
                                        Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerRepair.text.toString());
                                        Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerRepair.text.toString());

                                        if (device_sn == null && device_qr == null) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                            title: const Text('UWAGA'),
                                            content: const Text('Nie znaleziono urządzenia'),
                                            actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.pink,
                                              ),
                                              child: Text('OK',),
                                              onPressed: () {
                                                _controllerRepair.clear();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            // TextButton(
                                            //   style: TextButton.styleFrom(
                                            //     foregroundColor: Colors.green,
                                            //   ),
                                            //   child: Text('Wyszukaj ponownie'),
                                            //   onPressed: () {
                                            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceAdd()));
                                                
                                            //   },
                                            // ),
                                          ]    
                                          ));
                                          
                                        } else {
                                          if (device_qr != null) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RepairPage(deviceObject: device_qr)));
                                          } 
                                          if (device_sn != null) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RepairPage(deviceObject: device_sn)));

                                          }
                                          
                                        }
                                        _controllerRepair.clear();

                                      },
                                      controller: _controllerRepair,
                                      textAlign: TextAlign.center,
                                      // initialValue: widget.categoryObject.name.toString(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Wprowadź SN lub kod QR przedmiotu',
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
                                        _controllerRepair.text = result.rawContent.toString();
                                        Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerRepair.text.toString());
                                        Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerRepair.text.toString());

                                        if (device_sn == null && device_qr == null) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                            title: const Text('UWAGA'),
                                            content: const Text('Nie znaleziono urządzenia'),
                                            actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.pink,
                                              ),
                                              child: Text('OK',),
                                              onPressed: () {
                                                _controllerSearch.clear();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            // TextButton(
                                            //   style: TextButton.styleFrom(
                                            //     foregroundColor: Colors.green,
                                            //   ),
                                            //   child: Text('Dodaj'),
                                            //   onPressed: () {
                                            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeviceAdd()));
                                                
                                            //   },
                                            // ),
                                          ]    
                                          ));
                                          
                                        } else {
                                          if (device_qr != null) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RepairPage(deviceObject: device_qr)));
                                          } 
                                          if (device_sn != null) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RepairPage(deviceObject: device_sn)));

                                          }
                                          
                                        }
                                        _controllerRepair.clear();
                                      }
                                      
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ), 
                        
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
        );
        }
      )
      );
    }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                Center(
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}