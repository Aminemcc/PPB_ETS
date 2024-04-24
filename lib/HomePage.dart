import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'QuotePage.dart';
import 'SolverPage.dart';
import 'WorldTime.dart';
import 'ChooseLocation.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _time = '';
  String _chosenLocation = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTime();
  }

  Future<void> _loadTime() async {
    WorldTime worldTime = WorldTime('Asia/Jakarta');
    await worldTime.getTime();
    setState(() {
      _time = _formatTime(worldTime.time);
      _loading = false;
    });
  }

  String _formatTime(String time) {
    return time.substring(0, time.length - 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/bg-home.gif',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Welcome Muhammad Amin',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                _loading
                    ? CircularProgressIndicator()
                    : Column(
                  children: <Widget>[
                    Text(
                      'Current Time:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _time,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Chosen Location: $_chosenLocation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final selectedTimezone = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseLocationPage()),
                    );
                    if (selectedTimezone != null) {
                      WorldTime worldTime = WorldTime(selectedTimezone);
                      await worldTime.getTime();
                      setState(() {
                        _time = _formatTime(worldTime.time);
                        _chosenLocation = selectedTimezone;
                      });
                    }
                  },
                  child: Text(
                    'Choose Location',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuotePage()),
                    );
                  },
                  child: Text(
                    'Go to Quotes Page',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SolverPage()),
                    );
                  },
                  child: Text(
                    'Go to Solver Page',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
