import 'package:flutter/material.dart';
import 'package:flutterapp/services/business.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {
  // Future variable
  Future<List<Business>>_futureData;

  @override
  void initState() {
    super.initState();
    // hit API and assign value ONCE when widget is added to the tree
    _futureData = fetchBusinessList();
  }
  // render the future to the screen via FutureBuilder
  @override
  Widget build (BuildContext context){
    // TODO: implement build
    return FutureBuilder<List<Business>>(
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
                          image: new NetworkImage(snapshot.data[index].image_url),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Card(
                      child: Text('${snapshot.data[index].name}'),
                    ),
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        // default show a loading spinner
        return Center (child: CircularProgressIndicator());
      });
  }
}