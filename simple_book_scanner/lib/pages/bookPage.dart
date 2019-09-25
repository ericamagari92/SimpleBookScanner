import 'package:flutter/material.dart';
import 'package:simple_book_scanner/databaseManager/database.dart';
import '../book/book.dart';

/*

This page show the available informations about a book
(scanned or from the favorites' list).
Contains a Scaffold with an AppBar.
The title of the AppBar is the book's code.
A floatingActionButton is displayed if the informations
are taken via barcode scan, to add the book to the favorites.
If the informations are taken from the database,
the book is already a favorite so the button is not created.

*/

class BookPage extends StatefulWidget {
  final Book book;
  //bool that defines if the floatingActionButton must be
  //created or not.
  final bool canBeFavorite;

  BookPage({this.book, this.canBeFavorite});

  @override
  _BookPageState createState() => new _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //create the button according to the bool value
      floatingActionButton: widget.canBeFavorite
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  //change the appearence of the button
                  isFavorite = !isFavorite;
                });
                //add the book to the favorite's database
                bool result = await DBProvider.db.addFavorite(widget.book);
                if (result == null) {
                  //problem with creating or opening the database
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error saving favorite!"),
                          content: Text("Impossible to create database!"),
                        );
                      });
                } else if (result == true) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Great!"),
                          content: Text("Book added to favorites!"),
                        );
                      });
                } else if (result == false) {
                  //the book is already in the favorites' list
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Warning!"),
                          content: Text("Book already in favorites list!"),
                        );
                      });
                }
              },
              child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            )
          : new Container(),
      appBar: new AppBar(
        title: Text(
          //the code of the book
          widget.book.code,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              fontSize: 16.0),
        ),
      ),
      body: new ListView(
        //this ListView shows all the informations about the book
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "Authors",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  widget.book.authors != "?"
                      ? widget.book.authors
                      : "No authors informations is available for this book",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "Title",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  widget.book.title != "?"
                      ? widget.book.title
                      : "No title information is available for this book",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "Publishers",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  widget.book.publishers != "?"
                      ? widget.book.publishers
                      : "No publishers informations is available for this book",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "Publish date",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  widget.book.publish_date != "?"
                      ? widget.book.publish_date
                      : "No publish date is available for this book",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
