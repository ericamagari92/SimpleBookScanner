import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simple_book_scanner/book/book.dart';
import 'package:simple_book_scanner/pages/bookPage.dart';

/*

Helper functions to get informations about the book 
from OpenLibrary, scanning the barcode.

*/

//send an HTTP get request to get the informations of the scanned book
//from OpenLibrary
Future<void> openBookInfos(String code, BuildContext context) async {
  //add try
  try {
    http
        .get(
            'https://openlibrary.org/api/books?bibkeys=ISBN:$code&format=json&jscmd=data')
        .then((response) {
      //decode the response in JSON format
      Map<String, dynamic> bookInfos = jsonDecode(response.body);
      String isbn = "ISBN:$code";

      List<String> authors = new List<String>();
      List<String> publishers = new List<String>();

      if (bookInfos[isbn] == null) {
        //the book is not found in the database of OpenLibrary
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error!"),
                content: Text("This book is not on the OpenLibrary database!"),
              );
            });
        return;
      }

      if (bookInfos[isbn]["authors"] != null) {
        for (Map<String, dynamic> element in bookInfos[isbn]["authors"]) {
          //save a list of authors
          authors.add(element["name"]);
        }
      }
      if (bookInfos[isbn]["publishers"] != null) {
        for (Map<String, dynamic> element in bookInfos[isbn]["publishers"]) {
          //save a list of publishers
          publishers.add(element["name"]);
        }
      }
      //create a Book (book/book.dart).
      //List fields are transformed to strings with the
      //_buildString function, written below
      Book book = new Book(
          code: code,
          title: bookInfos[isbn]["title"] ?? "?",
          publishers: _buildString(publishers),
          publish_date: bookInfos[isbn]["publish_date"] ?? "?",
          authors: _buildString(authors));
      //open BookPage to show received informations
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BookPage(
                    book: book,
                    canBeFavorite: true,
                  )));
    });
  } catch (e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error!"),
            content: Text(
                "Something went wrong with the connection to OperLibrary!"),
          );
        });
    // return false;
  }
}

//build a string given a list of strings
String _buildString(List<String> stringList) {
  var result = StringBuffer();
  int listLen = stringList.length - 1;
  for (int i = 0; i < listLen; i++) {
    result.write(stringList[i] + ",");
  }
  if (listLen > -1) {
    result.write((stringList[listLen]));
  } else {
    return "?";
  }

  return result.toString();
}

//this function opens the camera after checked the camera permission
//and scans a barcode. It returns the barcode as a string
Future<String> scanBarcode(BuildContext context) async {
  try {
    String barcode = await BarcodeScanner.scan();
    return barcode;
  } on PlatformException catch (e) {
    //appears a dialog to request the camera permissions
    //if the user says "No" it returns null;
    return null;
  } on FormatException catch (e) {
    print(
        "User returned using the \"back\"-button before scanning anything. Result");
    return null;
  } catch (e) {
    print('Unknown error: $e');
    return null;
  }
}
