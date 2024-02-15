import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message/services/auth.dart';

class MessageScreen extends StatefulWidget {
  User? user;
  AuthServices authServices;
  MessageScreen({required this.user, required this.authServices});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  User? user;
  AuthServices? authServices;
  @override
  void initState() {
    user = widget.user;
    authServices = widget.authServices;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async{
            await authServices!.signOut();
            }, icon: Icon(Icons.logout, color: Colors.blueGrey,))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenu"),
            Text("Uid : ${user!.uid}")
          ],
        ),
      ),
    );
  }
}
