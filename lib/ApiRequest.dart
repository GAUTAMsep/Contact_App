import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:contact_app_new/CallBackListener.dart';
class ApiRequest {
  final JsonDecoder _decoder = new JsonDecoder();
  String url, action = "";
  Map<String, String> headers;
  int statusCode = 0;
  bool onlyOnce = false;
  BuildContext mContextLoader;
  dynamic body;
  dynamic resultFinal;
  BuildContext mContext;
  Encoding encoding;
  CallBackListener callBackListener;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  ApiRequest(BuildContext mContext, CallBackListener callBackListener,
      String url, String action) {
    this.callBackListener = callBackListener;
    this.url = url;
    this.encoding = encoding;
    this.mContext = mContext;
    this.action = action;
    _showLoader(mContext);
    getData();
  }

// for requesting API by 'post' or 'get'  method....................
  Future<dynamic> getAPIRequest(String url) async {

    if (body != null)
      return http
          .post(url)
          .then((http.Response response) {
        onlyOnce = false;
        final String res = response.body;
        statusCode = response.statusCode;
        print("===result===response${response.body}");
        print("===result===$res");
        print("===resultCode===$statusCode");
        if (statusCode == 401){

        }
        resultFinal = _decoder.convert(res);
        Navigator.pop(mContextLoader);
        callBackListener.callBackFunction(action, resultFinal,true);
        return _decoder.convert(res);
      }).catchError((onError) {
        onlyOnce = false;
        print("===onError===from server" + onError.toString());
        Navigator.pop(mContext);
        callBackListener.callBackFunction(action, resultFinal,false);
      });
    else
      return http.get(url).then((http.Response response) {
        onlyOnce = false;
        final String res = response.body;
        statusCode = response.statusCode;
        print("===result===response${response.body}");
        print("===result===" + res.toString());
        print("===resultCode===$statusCode");
        resultFinal = _decoder.convert(res);
        Navigator.pop(mContextLoader);
        callBackListener.callBackFunction(action, resultFinal,true);
        return _decoder.convert(res);
      }).catchError((onError) {
        onlyOnce = false;
        print("===onError===from server" + onError.toString());
        Navigator.pop(mContextLoader);
        callBackListener.callBackFunction(action, onError.toString(),false);
      });
  }

  Future<Null> _showLoader(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context1) {
        Future<bool> _onWillPop() {
          return null;
        }
        mContextLoader = context1;
        return WillPopScope(
            onWillPop: _onWillPop,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator
                        (
                        backgroundColor: Colors.pink,
                      ),
                      height: 50.0,
                      width: 50.0,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
  Future<Null> getData() async {
    getAPIRequest(url);
  }
}
