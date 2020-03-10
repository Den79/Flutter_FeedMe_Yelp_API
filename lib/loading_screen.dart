import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {
  // Future variable
  Future<String>_futureData;

  @override
  void initState() {
    super.initState();
    // hit API and assign value ONCE when widget is added to the tree
    _futureData = _fetchBusinessList();
  }

  // returns a Future asynchronously
  Future<String> _fetchBusinessList() async {
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
    // later we will return a collection of Businesses
    return "SUCCESS!";
  }

  // render the future to the screen via FutureBuilder
  @override
  Widget build (BuildContext context){
    // TODO: implement build
    return FutureBuilder<String>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        // default show a loading spinner
        return CircularProgressIndicator();
      });
  }
}