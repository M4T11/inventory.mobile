import 'package:flutter/material.dart';
import 'package:inventoryapp/screens/category_page.dart';
import 'package:inventoryapp/screens/device_page.dart';
import 'package:inventoryapp/screens/ean_device_page.dart';
import 'package:inventoryapp/screens/location_page.dart';
import 'package:inventoryapp/screens/producer_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Inventory App'),
      backgroundColor: Color(0xff235d3a),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            // MAGAZYN
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
              elevation: 1.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff73c088),
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(width: 1, color: Color(0xff235d3a)),
                  ),
                child: InkWell(
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => DevicePage()));},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Center(
                          child: Icon(
                        Icons.house_rounded,
                        size: 40.0,
                        color: Colors.white,
                      )),
                      SizedBox(height: 20.0),
                      Center(
                        child: Text("Magazyn",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              )),
              // LOKALIZACJE
              Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
              elevation: 1.0,
              margin: EdgeInsets.all(8.0),
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
              margin: EdgeInsets.all(8.0),
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
              // PRODUCENCI
              Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
              elevation: 1.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff73c088),
                  borderRadius: BorderRadius.circular(12),
                  ),
                child: InkWell(
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProducerPage()));},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Center(
                          child: Icon(
                        Icons.construction_rounded,
                        size: 40.0,
                        color: Colors.white,
                      )),
                      SizedBox(height: 20.0),
                      Center(
                        child: Text("Producenci",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              )),
              // URZADZENIA EAN
              Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
              elevation: 1.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff73c088),
                  borderRadius: BorderRadius.circular(12),
                  ),
                child: InkWell(
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => EanDevicePage()));},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Center(
                          child: Icon(
                        Icons.devices_rounded,
                        size: 40.0,
                        color: Colors.white,
                      )),
                      SizedBox(height: 20.0),
                      Center(
                        child: Text("Urządzenia EAN",
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