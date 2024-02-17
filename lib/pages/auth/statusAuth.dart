import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:message/model/User.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/pages/messages/message.dart';
import 'package:message/services/auth.dart';
import 'package:message/services/db.dart';

class StatusAuthScreen extends StatefulWidget {
  const StatusAuthScreen({Key? key}) : super(key: key);

  @override
  State<StatusAuthScreen> createState() => _StatusAuthScreenState();
}

class _StatusAuthScreenState extends State<StatusAuthScreen> {
  // Déclartions des variables
  UserModel? user;
  AuthServices authServices = AuthServices();

  Future<void> getUser() async{
    final result = await authServices.user;
   if(result == null){
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => LoginScreen(authServices: authServices)), (route) => false);
   }else{
     final userResult = await DbServices().getUser(result!.uid);
     setState(() {
       user = userResult;
     });
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => MessageScreen(user: user, authServices: authServices)), (route) => false);
   }

  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitCircle(color: Colors.lightBlue,size: 50,)
      ),
    );
  }
}
