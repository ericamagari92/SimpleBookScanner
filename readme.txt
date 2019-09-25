This is the repository for a Flutter project of a simple barcode scanner.

The first page shows two buttons:
-one to go to the FavoritesPage, where is shown a list of books liked by 
the user, saved in a database containing only one table, called Books.
Touching the title of the book in this list, the BookPage with the book informations is open.
This database is created using the SQFLite plugin.
-one to open the camera to scan the barcode of a book.
When the code is received, it starts an http get request to OpenLibrary to 
get the informations available, and the BookPage is created.

BookPage:
Lists the informations about a book.
If the book is taken from a scan, a floatingActionButton appears.
this button allows the user to add the book to the favorites table in the database.

Flutter version used: 1.7.8+hotfix.4-stable