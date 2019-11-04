import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
class CommonMethods{

  static dynamic date1;
  File imageFile;
  static int getColorHexFromStr(String colorStr){
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for(int i= 0; i< len ; i++)
      {
        int hexDigit =colorStr.codeUnitAt(i);
        if (hexDigit >=48 && hexDigit <= 57){
          val +=(hexDigit - 48) * (1 << (4 * (len - 1 - i)));
        }
        else if (hexDigit >=65 && hexDigit <= 70){
          val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
        }
        else if(hexDigit >= 97 && hexDigit <= 102){
          val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
        }
        else{
          throw new FormatException("An error occurred when converting a color");
        }
      }
    return val;

  }
  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  static void savePreferenceValues(String key , String value) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }
  static Future<String> getPreferenceValues(String key)async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
}
  static void showInSnackBar(String errorMessage, MaterialColor red,
      GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: new Text(errorMessage),
      backgroundColor: red,
    ));
  }
  Future<bool> checkInternetConnectivity() async {
    String connectionStatus;
    bool isConnected = false;
    final Connectivity _connectivity = Connectivity();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.mobile) {
        print("===internetconnected==Mobile" + connectionStatus);
        isConnected = true;
        // I am connected to a mobile network.
      } else if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.wifi) {
        isConnected = true;
        print("===internetconnected==wifi" + connectionStatus);
        // I am connected to a wifi network.
      } else if (await _connectivity.checkConnectivity() ==
          ConnectivityResult.none) {
        isConnected = false;
        print("===internetconnected==not" + connectionStatus);
      }
    } on PlatformException catch (e) {
      print("===internet==not connected" + e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
    return isConnected;
  }
  static void clearPreferences(){
    savePreferenceValues("", "");
  }

  static void hideSoftKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }




}