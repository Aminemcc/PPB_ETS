import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  String time = "";
  String url = ""; // location url for api endpoint

  WorldTime(String new_url) {
    this.url = new_url;
    print(this.url);
  }

  Future<void> getTime() async {

    final api_url = Uri.parse('http://worldtimeapi.org/api/timezone/$url');
    Response response = await get(api_url);
    Map data = jsonDecode(response.body);


    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1,3);


    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    print(now);

    time = now.toString();
  }

}

