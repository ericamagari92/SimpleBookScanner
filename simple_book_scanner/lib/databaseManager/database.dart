import 'dart:io';
import '../book/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

/*

This class manages all the operations permitted for a local database,
using SQFLite plugin. It is possible to get the favorite books,
add one book ore delete one.

*/

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    try {
      //initialize the database. If it do not exists, it creates it.
      //the Books table contains all the informations of the book,
      //described by the Book class (book/book.dart)
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "SimpleScannerDatabase.db");
      return await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Books ("
            "code TEXT,"
            "title TEXT,"
            "authors TEXT,"
            "publishers TEXT,"
            "publish_date TEXT"
            ")");
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> addFavorite(Book book) async {
    final db = await database;
    if (db == null) {
      //there is a problem in opening the database
      return null;
    }
    var res =
        await db.query("Books", where: "code = ?", whereArgs: [book.code]);
    if (res.length > 0) {
      return false;
    }
    //add the book to the Books table, modifying the textfields to save
    //them properly
    var resInsert = await db.rawInsert(
        "INSERT Into Books (code, title, authors, publishers, publish_date)"
        " VALUES (\'${book.code}\',"
        "\'${book.title.replaceAll(" ", "_").replaceAll("'", "")}\',"
        "\'${book.authors.replaceAll(" ", "_").replaceAll(",", "&")..replaceAll("'", "")}\',"
        "\'${book.publishers.replaceAll(" ", "_").replaceAll(",", "&")..replaceAll("'", "")}\',"
        "\'${book.publish_date}\'"
        ")");

    return true;
  }

  Future<bool> deleteFavorite(String code) async {
    final db = await database;
    if (db == null) {
      //there is a problem in opening the database
      return null;
    }
    //delete the corresponding book
    var res = await db.delete("Books", where: "code = ?", whereArgs: [code]);

    return true;
  }

  getFavorites() async {
    final db = await database;
    if (db == null) {
      //there is a problem in opening the database
      return null;
    }
    //return all the books inside the Books table
    List<Book> books = new List<Book>();
    var res = await db.query("Books");
    for (var element in res.toList()) {
      Book b = Book(
        code: element["code"],
        title: element["title"],
        publish_date: element["publish_date"],
        publishers: element["publishers"],
        authors: element["authors"],
      );
      books.add(b);
    }
    return books;
  }
}
