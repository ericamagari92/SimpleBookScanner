import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_book_scanner/databaseManager/database.dart';
import '../book/book.dart';
import 'package:simple_book_scanner/pages/bookPage.dart';

/*

This file describes the implementation of the Favorites view.
Contains a Scaffold with an AppBar, with title
"Your favorite books" and a ListView.
Each item of the ListView represents a book.
The book is identified by its title, and on the right
there is a button to delete the book from the favorites
(that is deleting its row on the database).
Touching the ListView item opens a BookPage,
showing the informations about the book. In the BookPage in
this case the "like" button do not appear since the book
is already a favorite.

*/

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

  //the list of the books in the database
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
          //this takes the informations about the favorite books
          //from the database, shows a CircularProgressIndicator while
          //it is busy and when the result is ready it populates the
          //ListView
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

                  return new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          //tap to open the BookPage
                          GestureDetector(
                              onTap: () {
                                //open the BookPage passing the informations as argument
                                //canBeFavorite: false means that the floatingActionButton
                                //to like the book must not be created
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
                                  //this contains the title of the book
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
                                                //the title of the book
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
                                          //icon to delete the book from the favorites' database
                                          child: IconButton(
                                            icon: new Icon(Icons.delete),
                                            onPressed: () async {
                                              DBProvider.db
                                                  .deleteFavorite(
                                                      books[index].code)
                                                  .then((result) {
                                                if (result == true) {
                                                  //a message to advice that the book has been
                                                  //deleted correctly
                                                  SnackBar snack = new SnackBar(
                                                    content:
                                                        Text("Book deleted!"),
                                                  );
                                                  Scaffold.of(context)
                                                      .showSnackBar(snack);
                                                  setState(() {});
                                                } else {
                                                  //advice the user that there was an error on
                                                  //creating or opening the database
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Error deleting favorite!"),
                                                          content: Text(
                                                              "Impossible to open database!"),
                                                        );
                                                      });
                                                }
                                              });
                                            },
                                          ))
                                    ],
                                  ))),
                          //a delimiter for each item of the ListView
                          new Container(
                            color: Colors.grey,
                            height: 1.0,
                          )
                        ],
                      );
                    },
                    itemCount: books.length,
                  );
                } else {
                  //the database contains no data
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
