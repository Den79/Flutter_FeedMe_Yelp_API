import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Business {
  final String id;
  final String name;
  final String image_url;

  Business ({this.id, this.name, this.image_url});

  factory Business.fromJson(Map<String, dynamic> json){
    return Business(
      id: json['id'],
      name: json['name'],
      image_url: json['image_url']
    );
  }
}

// returns a Future asynchronously
Future<List<Business>> fetchBusinessList() async {
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
  // get the businesses from the response
  Iterable decodedData = jsonDecode(response.body)['businesses'];
  // extract the names to a list
  List<Business> business = decodedData.map((businessJson) => Business.fromJson(businessJson)).toList();
  return business;
}