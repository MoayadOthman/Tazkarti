// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonMethods{
//   checkConnectivity(BuildContext context)async{
//     var connectionResults=await Connectivity().checkConnectivity();
//     if(connectionResults!=ConnectivityResult.mobile && connectionResults!=ConnectivityResult.wifi)
//     {
//       if(!context.mounted) return;
//       displaySnackBar('تأكد من إنك متصل بالإنترنت ',context);
//     }
//   }
//
  displaySnackBar(String messageText, BuildContext context){
    var snackBar=SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}