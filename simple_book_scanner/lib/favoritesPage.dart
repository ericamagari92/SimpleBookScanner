import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'book.dart';
import 'bookPage.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => new _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Book> books = new List<Book>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text(
          "Your favorite books",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              fontSize: 16.0),
        )),
        body: new FutureBuilder(
          future: DBProvider.db.getFavorites(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xFFb21900))));
              case ConnectionState.none:
                return Container();

              case ConnectionState.done:

                if (snapshot.hasData) {
                  books = snapshot.data;
                  //print(books.toString());

                  return new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      print("indice " + index.toString());
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BookPage(
                                              book: books[index],
                                              canBeFavorite: false,
                                            )));
                              },
                              child: Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(left: 25.0),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                books[index].title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.0),
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 15.0),
                                          child: IconButton(
                                            icon: new Icon(Icons.delete),
                                            onPressed: () async {
                                              DBProvider.db
                                                  .deleteFavorite(
                                                      books[index].code)
                                                  .then((result) {
                                                    if(result == true ){
                                                SnackBar snack = new SnackBar(
                                                  content:
                                                      Text("Book deleted!"),
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(snack);
                                                setState(() {}); }
                                                    else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text("Error deleting favorite!"),
                                                              content: Text("Impossible to open database!"),
                                                            );
                                                          });
                                                    }
                                              });
                                            },
                                          ))
                                    ],
                                  ))),
                          new Container(
                            color: Colors.grey,
                            height: 1.0,
                          )
                        ],
                      );
                    },
                    itemCount: books.length,
                  );
                } //else segnalare errore
                else {
                  return new Container();
                }
                return new Container();
              default:
                return new Container();
            }
          },
        ));
  }
}
