import 'package:flutter/material.dart';
import 'package:inventoryapp/models/device_model.dart';
import 'package:inventoryapp/screens/category_page.dart';
import 'package:inventoryapp/screens/device_add.dart';
import 'package:inventoryapp/screens/device_details.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/screens/producer_page.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:provider/provider.dart';
import 'package:inventoryapp/provider/device_provider.dart';
import 'package:collection/collection.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    final TextEditingController _controllerSearch =  TextEditingController();

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
              reverse: true,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: (1 / 0.5),
                    crossAxisCount: 1,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
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
                                        print("search");
                                        Device? device_sn = devices.firstWhereOrNull((x) => x.serialNumber == _controllerSearch.text.toString());
                                        Device? device_qr = devices.firstWhereOrNull((x) => x.qrCode == _controllerSearch.text.toString());
                                        print(device_qr);
                                        print(device_sn);
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
                                        print(device_qr);
                                        print(device_sn);

                                        if (device_sn == null && device_qr == null) {
                                          print('HALO');
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
                                      }
                                      
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                        // LOKALIZACJE
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
                            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage()));},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              verticalDirection: VerticalDirection.down,
                              children: <Widget>[
                                SizedBox(height: 50.0),
                                Center(
                                    child: Icon(
                                  Icons.map_rounded,
                                  size: 40.0,
                                  color: Colors.white,
                                )),
                                SizedBox(height: 20.0),
                                Center(
                                  child: Text("Lokalizacje",
                                      style:
                                          TextStyle(fontSize: 18.0, color: Colors.white)),
                                )
                              ],
                            ),
                          ),
                        )),
                        // KATEGORIE
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
                            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryPage()));},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              verticalDirection: VerticalDirection.down,
                              children: <Widget>[
                                SizedBox(height: 50.0),
                                Center(
                                    child: Icon(
                                  Icons.category_rounded,
                                  size: 40.0,
                                  color: Colors.white,
                                )),
                                SizedBox(height: 20.0),
                                Center(
                                  child: Text("Kategorie",
                                      style:
                                          TextStyle(fontSize: 18.0, color: Colors.white)),
                                )
                              ],
                            ),
                          ),
                        )),
                        
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