import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.redAccent
      ),
      
      home: HomePage()
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String fullname = "";

  String address_1 = "";
  String address_2 = "";
  String license_num = "";
  String vehicle_model = "";

  File _image;
  String _selectedState = "Select a State";
  DateTime dob;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
List<String> states = ['New South Wales','Queensland','South Australia','Tasmania','Victoria','Western Australia','Australian Capital Territory','Northern Territory'];

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2001),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              autofocus: false,
              onChanged: (text){fullname=text;},
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Full Name',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              autofocus: false,
              onChanged: (text){address_1=text;},
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Address Line 1',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              autofocus: false,
              onChanged: (text){address_2=text;},
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Address Line 2',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),



          Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: Column(
                children: <Widget>[
                  Text("${selectedDate.toLocal()}"),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select DOB'),
                  ),
                ],
              )
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              autofocus: false,
              onChanged: (text){license_num=text;},
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Driving License Number',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: new DropdownButton<String>(
              hint: Text(_selectedState),

              items: states.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {setState(() {
                _selectedState = value;
              });},
            )

          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              autofocus: false,
              onChanged: (text){vehicle_model=text;},
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Vehicle Model',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),

          Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: Column(
                children: <Widget>[
                  Text("Driving License Image"),
                  FlatButton(onPressed: getImage, child: Text("Upload")),

                ],
              )
          ),

<<<<<<< HEAD
//          Padding(
//              padding: const EdgeInsets.fromLTRB(20,10,20,10),
//              child: RaisedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Signature()));},child: Text("Signature"),)
//          ),
=======
        //  Padding(
        //      padding: const EdgeInsets.fromLTRB(20,10,20,10),
          //    child: RaisedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Signature()));},child: Text("Signature"),)
          //),
>>>>>>> bcc62bae62ea3be7c433bb235f785edb5ea4dd85





        ],
      ),
    );
  }
}

