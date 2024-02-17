import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/model/User.dart';
import 'package:message/widgets/myTextFieldForm.dart';

class ModifierMotDePasse extends StatefulWidget {
  UserModel user;
  ModifierMotDePasse({required this.user});

  @override
  State<ModifierMotDePasse> createState() => _ModifierMotDePasseState();
}

class _ModifierMotDePasseState extends State<ModifierMotDePasse> {
  // Déclaration des variables
  UserModel? user;
  String? ancien_mot_depasse, nouveau_mot_de_passe, confirmer_mot_de_passe;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Changer mot de passe", style: style.copyWith(color: Colors.lightBlue, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.update, color: Colors.lightBlue,))
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Form(
          key: _key,
          child: Column(
            children: [
              MyTextFieldForm(
                  name: "Ancien mot de passe",
                  onChanged: () => (value){
                    ancien_mot_depasse = value;
                  }, validator: () => (value){
                    if(value == null || value.isEmpty){
                      return "Veuillez saisir votre ancien mot de passe";
                    }
              },
                  iconData: Icons.password,
                  textInputType: TextInputType.text,
                  edit: false,
                  value: ""),
              MyTextFieldForm(
                  name: "Nouveau mot de passe",
                  onChanged: () => (value){
                    nouveau_mot_de_passe = value;
                  }, validator: () => (value){
                if(value == null || value.isEmpty){
                  return "Veuillez saisir votre nouveau mot de passe";
                }
              },
                  iconData: Icons.password_outlined,
                  textInputType: TextInputType.text,
                  edit: false,
                  value: ""),
              MyTextFieldForm(
                  name: "Confirmer votre nouveau mot de passe",
                  onChanged: () => (value){
                    ancien_mot_depasse = value;
                  }, validator: () => (value){
                if(value == null || value.isEmpty){
                  return "Veuillez confirmer votre nouveau mot de passe";
                }else if(value != nouveau_mot_de_passe){
                  return "Vore mot de passe ne correspond pas!";
                }
              },
                  iconData: Icons.password_rounded,
                  textInputType: TextInputType.text,
                  edit: false,
                  value: ""),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: (){
                    if(_key.currentState!.validate()){
                      print("Ouid");
                    }else{
                      print("Non");
                    }
                  },
                  child: Text("Modifier", style: style.copyWith(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
