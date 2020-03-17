import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import '../util/utils.dart' as util;


class klimatic extends StatefulWidget {
  @override
  _klimaticState createState() => _klimaticState();
}

class _klimaticState extends State<klimatic> {
  String _cityEntered;

  Future _gotoNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangCity();
      })
    );
    
    if(results != null && results.containsKey('enter')){
      //print(results['enter'].toString());
      _cityEntered = results['enter'];
    }
    
  }

  void showStaff() async{
    Map data = await getWheather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
        title: new Text('Klimatic'
        ),
        centerTitle: true,

        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: (){
                _gotoNextScreen(context);
              })
        ],

      ),
      
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
            height: 1200.0,
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),

          new Container(
            alignment: Alignment.topRight,
            margin: new EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),

          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 350.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )


        ],
      ),
    );
  }

  Future<Map> getWheather(String appId, String city) async{

    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
    '${util.appId}&unit=imperial';

    http.Response response = await http.get(apiUrl);
    
    return json.decode(response.body);
  }


  Widget updateTempWidget(String city){

    return new FutureBuilder(
        future: getWheather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
        Map content = snapshot.data;

        return new Container(
          //margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
          child: new Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ListTile(
                title: new Text(content['main']['temp'].toString(),
                  style: new TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize:40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
                subtitle: new ListTile(
                  title: new Text(
                    "Humidity: ${content['main']['humidity'].toString()} F\n"
                    "Min: ${content['main']['temp_min'].toString()} F\n"
                    "Max: ${content['main']['temp_max'].toString()} F\n",
                    style: extraData(),

                ),
              )


              )],
          ),

        );
      }else{
          return new Container();
        }
    });

  }



}

class ChangCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter The City Name'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter': _cityFieldController.text
                      });
                    },
                    child: new Text('Get Weather'),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                ),
              )
            ],
          )
        ],
      )


    );
  }
}




TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 30.0,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 29.9,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal
  );
}
TextStyle extraData(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 15.9,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal
  );
}