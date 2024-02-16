import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';

import '../../fonctions/loadingShimmer.dart';

class UsersEnAtttenteScreen extends StatefulWidget {
  const UsersEnAtttenteScreen({Key? key}) : super(key: key);

  @override
  State<UsersEnAtttenteScreen> createState() => _UsersEnAtttenteScreenState();
}

class _UsersEnAtttenteScreenState extends State<UsersEnAtttenteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Utilisateurs en attente", style: style.copyWith(color: Colors.lightBlue, fontWeight: FontWeight.bold),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.lightBlue,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.people_outline, color: Colors.lightBlue,))
        ],
      ),
      body: LoadingShimmer(),
    );
  }
}
