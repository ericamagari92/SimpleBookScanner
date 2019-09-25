import 'package:flutter/material.dart';

/*
  Abstraction of a book.
  Contains the most relevant informations taken
  from OpenLibrary.
*/
class Book {
  final String code;
  final String title;
  final String authors;
  final String publishers;
  final String publish_date;

  const Book(
      {this.code,
      this.title,
      this.authors,
      this.publish_date,
      this.publishers});
}
