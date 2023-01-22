import 'package:flutter/material.dart';
import 'package:inventoryapp/screens/category_page.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Provider App'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
              elevation: 1.0,
              margin: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(220, 220, 220, 1.0),
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
                        Icons.book,
                        size: 40.0,
                        color: Colors.black,
                      )),
                      SizedBox(height: 20.0),
                      Center(
                        child: Text("Ordbog",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      )
                    ],
                  ),
                ),
              )),
            // makeDashboardItem("Ordbog", Icons.book),
            makeDashboardItem("Alphabet", Icons.alarm),
            makeDashboardItem("Alphabet", Icons.alarm),
            makeDashboardItem("Alphabet", Icons.alarm)
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