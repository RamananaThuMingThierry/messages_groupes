import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/pages/messages/message.dart';
import 'package:message/services/auth.dart';

class StatusAuthScreen extends StatefulWidget {
  const StatusAuthScreen({Key? key}) : super(key: key);

  @override
  State<StatusAuthScreen> createState() => _StatusAuthScreenState();
}

class _StatusAuthScreenState extends State<StatusAuthScreen> {
  // Déclartions des variables
  User? user;
  AuthServices authServices = AuthServices();

  Future<void> getUser() async{
    final result = await authServices.user;
    setState(() {
      user = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return user == null ? LoginScreen(authServices: authServices,) : MessageScreen(user: user, authServices: authServices,);
  }
}
