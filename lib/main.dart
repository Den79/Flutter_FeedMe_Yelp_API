import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  void fetchBusinessList() async {
    var response = await http.get(
      'https://api.yelp.com/v3/businesses/search' +
          "?&latitude=49.2820&longitude=-123.1171",
      headers: {
        HttpHeaders.authorizationHeader:
        "Bearer 4zMnFkShrFprc0JizCA_WEWIWRxHsHcx8wN5iSqu5AK83N8Oq7SEgjD7ufj06yanMrVdkK3F7N1qqsJ8YAyut0QnQqLKHkdajixrebOG1Pbmq9ICHU5872jpf41hXnYx"
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