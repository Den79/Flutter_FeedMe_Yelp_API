import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  void fetchBusinessList() async {
    await DotEnv().load('.env');
    Location location = new Location();
    await location.getLocation();
    var response = await http.get(
      'https://api.yelp.com/v3/businesses/search' +
          "?&latitude=${location.latitude}&longitude=${location.longitude}",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${DotEnv().env['API_KEY']}"
      },
    );
    print(json.decode(response.body));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fetchBusinessList();
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Center(
        child: Text("Yelp Businesses!"),
      ),
    );
  }
}