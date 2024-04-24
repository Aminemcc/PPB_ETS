import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'BookDB.dart';

class BookPage extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookPage> {
  final DBHelper bookDB = DBHelper();
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    initDatabaseAndLoadQuotes();
  }

  Future<void> initDatabaseAndLoadQuotes() async {
    await bookDB.database;
    await loadQuotes();
  }

  Future<void> loadQuotes() async {
    books = await bookDB.getData();
    setState(() {});
  }

  Future<void> _showAddQuoteDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Book newBook = Book(
                  id: 0,
                  text: quoteController.text,
                  author: authorController.text,
                );
                quoteDB.insertData(newQuote.toMap());
                loadQuotes();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditQuoteDialog(BuildContext context, Quote quote) async {
    TextEditingController quoteController =
    TextEditingController(text: quote.text);
    TextEditingController authorController =
    TextEditingController(text: quote.author);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: quoteController,
                decoration: InputDecoration(labelText: 'Quote'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Quote updatedQuote = Quote(
                  id: quote.id,
                  text: quoteController.text,
                  author: authorController.text,
                );
                quoteDB.updateData(updatedQuote.toMap());
                loadQuotes();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Database'),
          content: Text('Are you sure you want to reset the database? This will delete all quotes.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await quoteDB.resetDatabase();
                await loadQuotes();
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget quoteTemplate(Book book) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          book.text,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          'Description : ' + book.description,
          style: TextStyle(fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.blue,
              onPressed: () {
                _showEditQuoteDialog(context, book);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  books.remove(quote);
                });
                bookDB.deleteData(quote.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          return quoteTemplate(books[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuoteDialog(context);
        },
        tooltip: 'Add Book',
        child: Icon(Icons.add),
      ),
    );
  }
}
