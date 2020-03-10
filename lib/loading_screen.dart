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
  
  @override
  void initState() {
    super.initState();
    fetchBusinessList();
  }

  @override
  Widget build (BuildContext context){
    // TODO: implement build
    return Center(
      child: Text("Loading Screen")
    );
  }
}