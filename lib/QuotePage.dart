import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'QuoteDB.dart';

class QuotePage extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuotePage> {
  final DBHelper quoteDB = DBHelper();
  List<Quote> quotes = [];

  @override
  void initState() {
    super.initState();
    initDatabaseAndLoadQuotes();
  }

  Future<void> initDatabaseAndLoadQuotes() async {
    await quoteDB.database;
    await loadQuotes();
  }

  Future<void> loadQuotes() async {
    quotes = await quoteDB.getData();
    setState(() {});
  }

  Future<void> _showAddQuoteDialog(BuildContext context) async {
    TextEditingController quoteController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Quote'),
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
                Quote newQuote = Quote(
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

  Widget quoteTemplate(Quote quote) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          quote.text,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          'Author : ' + quote.author,
          style: TextStyle(fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.blue,
              onPressed: () {
                _showEditQuoteDialog(context, quote);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  quotes.remove(quote);
                });
                quoteDB.deleteData(quote.id);
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
        itemCount: quotes.length,
        itemBuilder: (BuildContext context, int index) {
          return quoteTemplate(quotes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuoteDialog(context);
        },
        tooltip: 'Add Quote',
        child: Icon(Icons.add),
      ),
    );
  }
}
