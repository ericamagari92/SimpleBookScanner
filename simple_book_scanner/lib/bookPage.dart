import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'book.dart';

class BookPage extends StatefulWidget {
  final Book book;
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
      floatingActionButton: widget.canBeFavorite
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isFavorite = !isFavorite;
                });

                bool result = await DBProvider.db.addFavorite(widget.book);
                if(result == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error saving favorite!"),
                          content: Text("Impossible to create database!"),
                        );
                      });
                }
                else if (result==true) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Great!"),
                          content: Text("Book added to favorites!"),
                        );
                      });
                } else if(result==false){

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
