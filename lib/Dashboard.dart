import 'dart:convert';
import 'package:contact_app_new/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:contact_app_new/ApiRequest.dart';
import 'package:contact_app_new/addContact.dart';
import 'package:contact_app_new/editContact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:contact_app_new/CallBackListener.dart';
class ContactListing extends StatefulWidget{
  @override
  _ContactListingState createState() => _ContactListingState();
}

class _ContactListingState extends State<ContactListing> implements CallBackListener{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  Color mainColor = Color(0xFF066c61);
  Color textColor = Color(0xFF898989);
  final dbHelper = DatabaseHelper.instance;
  final JsonDecoder _decoder = new JsonDecoder();
  dynamic resultFinal;
  var Fname = "";
  var Lname = "";
  var Mobile = "";
  var image_path = "";
  var data ;
  @override
  void initState() {
    // TODO: implement initState
//    contactSupportAPI();
    getAPIRequest();
    super.initState();

  }
  void SQFLite_dataStore() async {
    for(int index=0;index<data.length;index++)
    {
      dbHelper.fetch(data[index]['id']).then((value)async{
        if (value.isEmpty){
          print("insert");
          Map<String, dynamic> row = {
            DatabaseHelper.columnId:data[index]['id']!= null ?data[index]['id'].toString():"",
            DatabaseHelper.columnEmail:data[index]['email']!= null ?data[index]['email']:"",
            DatabaseHelper.columnFName:data[index]['first_name']!= null ?data[index]['first_name']:"",
            DatabaseHelper.columnLName:data[index]['last_name']!= null ?data[index]['last_name']:"",
            DatabaseHelper.columnImage:data[index]['avatar']!= null ?data[index]['avatar']:"",
       };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
          setState(() {
          });
        }
        else{
          Map<String, dynamic> row = {
            DatabaseHelper.columnId:data[index]['id']!= null ?data[index]['id'].toString():"",
            DatabaseHelper.columnEmail:data[index]['email']!= null ?data[index]['email']:"",
            DatabaseHelper.columnFName:data[index]['first_name']!= null ?data[index]['first_name']:"",
            DatabaseHelper.columnLName:data[index]['last_name']!= null ?data[index]['last_name']:"",
            DatabaseHelper.columnImage:data[index]['avatar']!= null ?data[index]['avatar']:"",

          };
          final id = await dbHelper.update(row);
          print('updated row id: $id');
          setState(() {
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Contacts',
            style: TextStyle(color: Colors.blue),
          ),
          leading: Container(),
          actions: [
            IconButton(
                icon: Image.asset(
                  'assets/Add.jpg',
                  height: 30,
                  width: 30,
                ),
                onPressed: () async {
                  Map result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => addContact()),
                  );
                  Fname = result['First_Name'];
                  Lname = result['Last_Name'];
                  Mobile = result['Mobile'];
                  image_path = result['Profile_Path'];
                  print("Result is     jkhgcjsa  " + result.toString());
                }),
          ],
        ),
        body: new Container(
          child:  new FutureBuilder<List<Map>>(
              future:  dbHelper.queryAllRows(),
              builder: (context , snapshot){
                if (snapshot.data !=  null && snapshot.data.length > 0) {
                  if (snapshot.hasData) {
                    return Container(
                      child: ListView.builder(
                          itemCount:  snapshot.data.length,
                          itemBuilder:  (context, index){
                            var firstname = snapshot.data[index]['First_Name'];
                            var lastname = snapshot.data[index]['Last_Name'];
                            return new Slidable(
                              delegate: new SlidableDrawerDelegate(),
                              secondaryActions: [
                                new IconSlideAction(
                                    caption: 'Edit',
                                    color: mainColor,
                                    icon: (Icons.edit),
                                    onTap: () {
                                      setState(() {
                                        var y = snapshot.data[index];
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => editContact(y)));
                                      });
                                    }
                                ),
                                new IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.black45,
                                    icon: Icons.delete,
                                    onTap:() {
                                      setState(() {
                                        var id = snapshot.data[index]['id'].toString();
                                      _delete(id);
                                      });
                                    }
                                ),
                              ],
                              child: new Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)
                                  ),
                                  child: Row(
                                    children: [

                                      Container(
                                          padding: const EdgeInsets.only(top: 15, left: 30, bottom: 15),
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 0.5),
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: snapshot.data[index]['Image_Path'] == ""
                                                      ? new ExactAssetImage('assets/profileicon.png')
                                                      : snapshot.data[index]['Image_Path'].toString().contains("http")? NetworkImage(snapshot.data[index]['Image_Path']):ExactAssetImage(snapshot.data[index]['Image_Path']),
                                                )),
                                          )),
                                      Container(

                                          padding: const EdgeInsets.only(left: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [

                                              Text(
                                                '$firstname $lastname',
                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                              ),
                                              Text(
                                                snapshot.data[index]['Email'],
                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )
                              ),
                            );
                          }
                      ),
                    );
                  } else {
                    return Container(
                        child: Center(
                          child: Text(
                            "No record(s) found",
                          ),
                        ));
                  }
                }
                else{
                  return Container(
                      child: Center(
                        child: Text(
                          "No record(s) found",
                        ),
                      ));
                }
              }

          ),
        ),
      ),
    );
  }

  void _delete(String id) async {
    final delete = await dbHelper.delete(id);
    print("deletet $delete");

  }

  Future contactSupportAPI() async {
    var url = "https://reqres.in/api/users?page=1";
    ApiRequest(context, this, url, "contact");

}
  Future<dynamic> getAPIRequest() async {
    var url = "https://reqres.in/api/users?page=1";
       http.get(url).then((http.Response response) {
        final String res = response.body;
        print("===result===response${response.body}");
        print("===result===" + res.toString());
//        print("===resultCode===$statusCode");
        resultFinal = _decoder.convert(res);
         data = resultFinal['data'];
         SQFLite_dataStore();
//        Navigator.pop(mContextLoader);
//        callBackListener.callBackFunction(action, resultFinal,true);
        return _decoder.convert(res);
      }).catchError((onError) {
//        onlyOnce = false;
        print("===onError===from server" + onError.toString());
//        Navigator.pop(mContextLoader);
//        callBackListener.callBackFunction(action, onError.toString(),false);
      });
  }

  @override
  callBackFunction(String action, result, bool isSuccess) {
    debugPrint("result===" + result.toString());
    debugPrint("action===" + action.toString());
  }
}