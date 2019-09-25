import 'package:flutter/material.dart';
import '../functions/getBookFunctions.dart';
import 'package:simple_book_scanner/pages/favoritesPage.dart';

/*

This is the very first page of the app. 
It contains a Scaffold with an AppBar with 
"Simple Book Scanner" as title. Contains two big buttons,
one to go to the FavoritesPage, the other to open the camera
and scan the book's barcode.

*/

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Simple Book Scanner",
          style: new TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontSize: 16.0),
        ),
      ),
      body: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //this button takes to the FavoritesPage,
                //that shows a list of the favorites books.
                new MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                FavoritesPage()));
                  },
                  child: new Icon(
                    Icons.favorite,
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                Text(
                  "Go to favorites list",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0),
                )
              ],
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new MaterialButton(
                //this button opens the camera to start scanning the book
                onPressed: () async {
                  //these two functions are written in functions/getBookFunctions.dart
                  String bookCode = await scanBarcode(context);
                  if (bookCode != null) openBookInfos(bookCode, context);
                },
                child: new Icon(
                  Icons.book,
                  size: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              Text(
                "Scan a book",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
