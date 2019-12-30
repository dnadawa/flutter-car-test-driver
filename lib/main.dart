import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_test_drive/sign.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        primaryColor: Color(0xffcd2024),
        accentColor: Color(0xff2f2f2f)
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
  final CollectionReference collectionReference = Firestore.instance.collection("users");

final TextEditingController namecon = TextEditingController();
  final TextEditingController ad1con = TextEditingController();
  final TextEditingController ad2con = TextEditingController();
  final TextEditingController linumcon = TextEditingController();
  final TextEditingController vehmodcon = TextEditingController();


  void add(){
    fullname = namecon.text;
    address_1 = ad1con.text;
    address_2 = ad2con.text;
    license_num = linumcon.text;
    vehicle_model = vehmodcon.text;



    Map<String,String> data = <String , String>{
      "date" : DateTime.now().toString(),
      "name" : fullname,
      "dob" : selectedDate.toString(),
      "Address Line 1": address_1,
      "Address Line 2": address_2,
      "License Number": license_num,
      "Vehicle Model": vehicle_model,
      "State": _selectedState,
      "Image": imgurl,
      "Signature": "Look in Firebase Storage/new folder",//this has to be change
    };

collectionReference.add(data);

    namecon.clear();
    ad1con.clear();
    ad2con.clear();
    linumcon.clear();
    vehmodcon.clear();
    image = null;
    imgurl = null;


  }


File image;
  String fullname = "";

  String address_1 = "";
  String address_2 = "";
  String license_num = "";
  String vehicle_model = "";

  String imgurl;
  String _selectedState = "Select a State";
  DateTime selectedDate = DateTime.now();



  Future getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    StorageReference ref = FirebaseStorage.instance.ref().child("$fullname.jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    imgurl = (await downloadUrl.ref.getDownloadURL());
    print("url is $imgurl");

  }


List<String> states = ['New South Wales','Queensland','South Australia','Tasmania','Victoria','Western Australia','Australian Capital Territory','Northern Territory'];



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
              padding: EdgeInsets.all(20),
            child: Image(image: AssetImage("assests/logo.png")),
            
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: namecon,
              autofocus: false,


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
              controller: ad1con,

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
              controller: ad2con,

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
              controller: linumcon,

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
            padding: const EdgeInsets.fromLTRB(30,20,30,20),
            child: TextFormField(
              autofocus: false,
              controller: vehmodcon,

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


          Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: RaisedButton(color:Colors.orange,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Sign(fullname: namecon.text)));},child: Text("Signature"),)
          ),

          Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: RaisedButton(onPressed: (){add();},child: Text("Submit!"),color: Colors.red,)
          ),







        ],
      ),
    );
  }
}

