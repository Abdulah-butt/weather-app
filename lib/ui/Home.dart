

import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double temperature,tem_min,tem_max;
  int humidity;
  String cityName=util.defaultCity;
  void ShowWeather() async{
    Map data=await getWeather(util.WeatherAPI, util.defaultCity);
    temperature=data["main"]["temp"];
    tem_min=data["main"]["temp_min"];
    tem_max=data["main"]["temp_max"];
    humidity=data["main"]["humidity"];
    print(data["main"]);
  }

  Future _nextScreen(BuildContext context) async{
    Map result=await Navigator.of(context).push(new MaterialPageRoute<Map>(builder: (BuildContext context){
      return new ChangeCityScreen();
    }));
    if(result['city'].toString()==""){

    }else{
        setState(() {
        cityName=result['city'].toString();
        updateTemperatureContainer();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Weather App",style: new TextStyle(color: Colors.black),),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            onPressed:(){
              _nextScreen(context);
            },
            icon: new Icon(Icons.menu),
          )
        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/umbrella.png", fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,),
          ),

          new Container(
          alignment: Alignment.topRight,
            margin: new EdgeInsets.fromLTRB(0, 30,30, 0),
            child: new Text("$cityName",style: textStyle(),),
          ),
          
          
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),


          // this container contains API data
          new Container(
            margin: new EdgeInsets.fromLTRB(30, 450, 0, 0),

            child:updateTemperatureContainer(),

          ),
        ],

      ),

    );
  }

  Future<Map> getWeather(String API_key,String City) async {
    var url=Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$City&appid=$API_key&units=imperial");
    http.Response response=await http.get(url);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Widget updateTemperatureContainer(){
    return new FutureBuilder(
      future: getWeather(util.WeatherAPI, cityName),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
          // here we get all info and json data , we setup widgets
          if(snapshot.hasData){
            Map content=snapshot.data;
            return Container(
              padding: new EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[

                      new Text(content["main"]["temp"].toString()+" F",
                        style:new TextStyle(fontSize: 55,color: Colors.white),
                      ),
                    ],
                  ),

                  new Row(
                    children: <Widget>[
                      new Text("Max  : ",
                        style: heading(),
                      ),
                      new Text(content["main"]["temp_max"].toString()+" F",
                        style: tempStyle(),
                      ),
                    ],
                  ),


                  new Row(
                    children: <Widget>[
                      new Text("Min  : ",
                        style: heading(),
                      ),
                      new Text(content["main"]["temp_min"].toString()+" F",
                        style: tempStyle(),
                      ),
                    ],
                  ),


                  new Row(
                    children: <Widget>[
                      new Text("Humidity : ",
                        style: heading(),
                      ),
                      new Text(content["main"]["humidity"].toString()+" F",
                        style: tempStyle(),
                      ),
                    ],
                  ),

                ],
              ),
            );
          }else{
            return new Container();
          }
          },
    );
  }
}


TextStyle textStyle(){
  return new  TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 20.0,
  );
}


TextStyle tempStyle(){
  return new  TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 20.0,
  );


}

TextStyle heading(){
  return new  TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 20.0,
  );
}















// 2nd screen


class ChangeCityScreen extends StatelessWidget {

  var txtCity=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
              child:new Image.asset("images/white_snow.png",
                height:double.infinity,
                width: 1200,
                fit: BoxFit.fill,
              ),

          ),
          new ListView(
            children: <Widget>[
              new TextField(
                controller: txtCity,
                keyboardType:TextInputType.text,
                decoration: new InputDecoration(
                  labelText: "Please Enter City Name",
                  hintText: "e.g Sialkot",
                ),

              ),

              new FlatButton(
                onPressed: (){
                  Navigator.pop(context,{
                    'city':txtCity.text
                  });
                },
                child: new Text("Get Weather",style: new TextStyle(color: Colors.white),),

                color: Colors.black38,
              )


            ],
          )
        ],
      ),
    );
  }
}
