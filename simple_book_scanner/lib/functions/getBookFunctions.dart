import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../book.dart';
import '../bookPage.dart';


Future<void> openBookInfos(String code, BuildContext context) async {
  //add try
  try {
    http.get(
        'https://openlibrary.org/api/books?bibkeys=ISBN:$code&format=json&jscmd=data')
        .then((response) {
      //print(response.body);
      //String body=response.body;
      Map<String, dynamic> bookInfos = jsonDecode(response.body);
      String isbn = "ISBN:$code";

      List<String> authors = new List<String>();
      List<String> publishers = new List<String>();

      if (bookInfos[isbn] == null) {
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
          print(element["name"]);
          authors.add(element["name"]);
        }
      }
      if (bookInfos[isbn]["publishers"] != null) {
        for (Map<String, dynamic> element in bookInfos[isbn]["publishers"]) {
          publishers.add(element["name"]);
        }
      }

      Book book = new Book(
          code: code,
          title: bookInfos[isbn]["title"] ?? "?",
          publishers: _buildString(publishers),
          publish_date: bookInfos[isbn]["publish_date"] ?? "?",
          authors: _buildString(authors)
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookPage(
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
            content: Text("Something went wrong with the connection to OperLibrary!"),
          );
        });
   // return false;
  }
}

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

Future<String> scanBarcode(BuildContext context) async {
  try {
    String barcode = await BarcodeScanner.scan();
    return barcode;
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      final Future<PermissionStatus> statusFuture = PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera)
          .then((PermissionStatus status) async {
        if (status != PermissionStatus.granted) {
          final List<PermissionGroup> permissions =
          new List<PermissionGroup>();
          permissions.add(PermissionGroup.camera);
          final Map<PermissionGroup, PermissionStatus>
          permissionRequestResult =
          await PermissionHandler().requestPermissions(permissions);
          PermissionHandler()
              .checkPermissionStatus(PermissionGroup.camera)
              .then((PermissionStatus status)  {
            if (status != PermissionStatus.granted) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Error!"),
                      content: Text("Please to use the scanner accept the camera permission!"),
                    );
                  });
              return null;
            }
          });
        }
      });
    }
    return null;
  } on FormatException catch (e) {
    print(
        'null (User returned using the "back"-button before scanning anything. Result)');
    return null;
  } catch (e) {
    print('Unknown error: $e');
    return null;
  }
}