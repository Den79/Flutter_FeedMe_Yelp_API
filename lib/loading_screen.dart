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
  Future<List<String>>_futureData;

  @override
  void initState() {
    super.initState();
    // hit API and assign value ONCE when widget is added to the tree
    _futureData = _fetchBusinessList();
  }

  // returns a Future asynchronously
  Future<List<String>> _fetchBusinessList() async {
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
    List<String> businessNames = decodedData.map((businessJson) => businessJson['name'].toString()).toList();
    return businessNames;
  }

  // render the future to the screen via FutureBuilder
  @override
  Widget build (BuildContext context){
    // TODO: implement build
    return FutureBuilder<List<String>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new NetworkImage(
                              "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Card(
                      child: Text('${snapshot.data[index]}'),
                    ),
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        // default show a loading spinner
        return CircularProgressIndicator();
      });
  }
}