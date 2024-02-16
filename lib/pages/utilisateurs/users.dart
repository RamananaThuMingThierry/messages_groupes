import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/loadingShimmer.dart';

class UtilisateursScreen extends StatefulWidget {
  const UtilisateursScreen({Key? key}) : super(key: key);

  @override
  State<UtilisateursScreen> createState() => _UtilisateursScreenState();
}

class _UtilisateursScreenState extends State<UtilisateursScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Utilisateurs", style: style.copyWith(color: Colors.lightBlue, fontWeight: FontWeight.bold),),
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
