import 'dart:io';
import 'package:contact_app_new/CommonMethods.dart';
import 'package:contact_app_new/database_helper.dart';
import 'package:contact_app_new/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class editContact extends StatefulWidget {
  @override
  editContact(this.title) : super();

  var  title;
  __MyAppStateState createState() => __MyAppStateState();


}

class __MyAppStateState extends State<editContact> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var value =  "";
  File _image;


  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;
  bool _validate4 = false;
  bool _validate6 = false;
  var errorMessage = "";


  Color mainColor = Color(0xFF066c61);

  var Fname = TextEditingController();
  var Lname = TextEditingController();
  var Email = TextEditingController();
  var Mobile = TextEditingController();
  @override
  void initState() {
    x = widget.title['First_Name'];
    y = widget.title['Last_Name'];
    z = widget.title['Email'];
    w = widget.title['Mobile'];
    Fname.text = x;
    Lname.text = y;
    Email.text = z;
    Mobile.text = w;
    super.initState();
  }
  var x,y,z,w;
  @override
  Widget build(BuildContext context) {

    Color textColor = Color(0xFF898989);
    imageSelectedGallery() async {
      var galleryFile =
      await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = galleryFile;
      });
      print('you ha ' + galleryFile.path);
    }

    Widget btn = Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                height: 140,
                width: 140,

                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5),
                    image: new DecorationImage(
                      fit: BoxFit.fill,

                      image: widget.title['Image_Path'] == ""? new ExactAssetImage('assets/profileicon.png'): _image == null ? widget.title['Image_Path'].toString().contains("http")?new NetworkImage(widget.title['Image_Path']):ExactAssetImage(widget.title['Image_Path']):new ExactAssetImage(_image.path),
                    )),
              )),
          Container(
            padding: const EdgeInsets.only(top: 100, left: 100),

            child: GestureDetector(
                child:

                Image.asset('assets/camera.png',height: 35,width: 35,),


                onTap: (imageSelectedGallery)),

          ),
        ],
      ),
    );
    Widget btn1 = Container(
      padding: const EdgeInsets.only(top: 40, left: 30),
      child: Row(
        children: [
          Text(
            'First Name',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );

    Widget btn2 = Container(
      padding: const EdgeInsets.only(top: 0, left: 30 , right: 30),
      child: Column(
        children: [
          TextField(
            controller: Fname,
            decoration: InputDecoration(
              errorText: _validate1 ? 'First Name is required' : null,
            ),
          ),
        ],
      ),
    );

    Widget btn3 = Container(
      padding: const EdgeInsets.only(top: 20, left: 30),
      child: Row(
        children: [
          Text(
            'Last Name',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );
    Widget btn4 = Container(
      padding: const EdgeInsets.only(top: 0, left: 30 , right: 30),
      child: Column(
        children: [
          TextField(
            controller: Lname,
            decoration: InputDecoration(

              errorText: _validate2 ? 'Last Name is required' : null,
            ),
          )
        ],
      ),
    ); Widget btn5 = Container(
      padding: const EdgeInsets.only(top: 20, left: 30),
      child: Row(
        children: [
          Text(
            'Email Address',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );
    Widget btn6 = Container(
      padding: const EdgeInsets.only(top: 0, left: 30 , right: 30),
      child: Column(
        children: [
          TextField(
            controller: Email,
            decoration: InputDecoration(

              errorText: _validate3 ? 'Email Address  is required' : _validate6 ? 'Enter Valid Email' : null,

            ),
          )
        ],
      ),
    ); Widget btn7 = Container(
      padding: const EdgeInsets.only(top: 20, left: 30),
      child: Row(
        children: [
          Text(
            'Mobile Number',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );

//    print("First Name"+Fname.text);
//    print("Last Name"+Lname.text);
//    print("Email Address"+Email.text);
//    print("Mobile Number"+Mobile.text);
    bool validate() {
      if (Fname.text.toString().trim().isEmpty) {
        errorMessage = "Enter First Name";
        return false;
      } else if (Email.text.toString().trim().isEmpty) {
        errorMessage = "Enter Email.";
        return false;
      }
      else if(!CommonMethods.validateEmail(Email.text.toString().trim())){
        errorMessage = "Enter Valid Email";
        return false;
      }
      return true;
    }

    Widget btn9 = Container(
        padding: const EdgeInsets.only(top: 20,),
        child: Column(
          children: [

            Container(
              child: GestureDetector(
                child: RaisedButton(
                  child: Text('Save'
                    ,style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  disabledColor: mainColor,

                ),
                onTap: (){

                  if (validate()){
                    var fname = Fname.text.toString();
                    var lname = Lname.text.toString();
                    var email = Email.text.toString();
                    var mobile = Mobile.text.toString();
                    var image = _image == null ? widget.title['Image_Path']: _image.path ;
                    _update(widget.title['id'],fname , lname, email  , image);

                    Navigator.pop(context);
                  }
                  else{
                    CommonMethods.showInSnackBar(
                        (errorMessage), Colors.red, _scaffoldKey);
                  }

                },
              ),
            )
          ],
        )
    );




    //Color mainColor = Color(0xFF066c61);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Contact',
          style: TextStyle(color: mainColor),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/Back.jpg',
                height: 18.0,
                width: 18.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: ListView(
        children: [btn, btn1, btn2, btn3, btn4, btn5, btn6,btn9
        ],
      ),
    );
  }
}

final dbHelper = DatabaseHelper.instance;
void _update(String id, String fname , String lname , String email, String image) async {

  // row to update
  Map<String, dynamic> row = {
    DatabaseHelper.columnId : id,
    DatabaseHelper.columnFName   : '$fname',
    DatabaseHelper.columnLName : '$lname',
    DatabaseHelper.columnEmail  : '$email',
    DatabaseHelper.columnImage  : '$image'

  };
  final rowsAffected = await dbHelper.update(row);
  print('updated $rowsAffected row(s)');
}
