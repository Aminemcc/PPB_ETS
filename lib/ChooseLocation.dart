import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChooseLocationPage extends StatefulWidget {
  @override
  _ChooseLocationPageState createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _timezones = [];
  List<String> _filteredTimezones = [];
  String _selectedTimezone = '';

  @override
  void initState() {
    super.initState();
    _fetchTimezones();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTimezones() async {
    final response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));
    if (response.statusCode == 200) {
      setState(() {
        _timezones = List<String>.from(jsonDecode(response.body));
        _filteredTimezones.addAll(_timezones);
      });
    } else {
      print('Failed to fetch timezones: ${response.statusCode}');
    }
  }

  void _onSearchChanged() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredTimezones = _timezones
          .where((timezone) => timezone.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredTimezones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredTimezones[index]),
            onTap: () {
              setState(() {
                _selectedTimezone = _filteredTimezones[index];
              });
              Navigator.pop(context, _selectedTimezone); // Pass back the selected timezone
            },
          );
        },
      ),
    );
  }
}
