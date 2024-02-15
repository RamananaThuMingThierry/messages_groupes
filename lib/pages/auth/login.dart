import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/pages/auth/register.dart';
import 'package:message/services/auth.dart';
import 'package:message/widgets/PasswordFiledForm.dart';
import 'package:message/widgets/myTextFieldForm.dart';

class LoginScreen extends StatefulWidget {
  AuthServices? authServices;
  LoginScreen({required this.authServices});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Déclarations des variables
  AuthServices? authServices;

  String? email, mot_de_passe;
  bool visibilite = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  @override
  void initState() {
    authServices = widget.authServices;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                child: Column(
                  children: [
                    Image(image: AssetImage("assets/logo.jpg"), width: 150),
                    Text("Club Chat", style: style.copyWith(color: Colors.lightBlue, fontSize: 25)),
                    SizedBox(height: 50,),
                    // Email
                    MyTextFieldForm(
                        edit: false,
                        value: "",
                        name: "Adresse e-mail",
                        onChanged: () => (value) => {
                          setState(() {
                            email = value;
                          })
                        },
                        validator: () => (value){
                          if(value == ""){
                            return "Veuillez saisir votre adresse e-mail!";
                          }else if(!regExp.hasMatch(value!)){
                            return "Votre adresse e-mail est invalide!";
                          }
                        },
                        iconData: Icons.email,
                        textInputType: TextInputType.emailAddress),
                    SizedBox(height: 10,),
                    // Mot de passe
                    PasswordFieldForm(
                        visibility: visibilite,
                        validator: () => (value){
                          if(value == ""){
                            return "Veuillez saisir votre mot de passe!";
                          }else if(value!.length < 8){
                            return "Votre mot de passe doit avoir au moins 8 caractères!";
                          }
                        },
                        name: "Mot de passe",
                        onTap: () => (){
                          setState(() {
                            visibilite = !visibilite;
                          });
                          print("${visibilite}");
                        },
                        onChanged: () => (value) => {
                          setState(() {
                            mot_de_passe = value;
                          })
                        }),
                    SizedBox(height: 20,),
                    //Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.lightBlue)
                          ),
                          onPressed: (){}, child: Text("Se connecte", style: style.copyWith(color: Colors.white),)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Avez-vous déjà un compte!", style: style.copyWith(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return LoginScreen(authServices: authServices,);
                  }), (route) => false);
                },
                child: Text("s'inscrire", style: style.copyWith(color: Colors.lightBlue)),
              )
            ]),
      ),
    );
  }
}
