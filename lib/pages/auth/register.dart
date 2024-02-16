import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/fonctions.dart';
import 'package:message/fonctions/loading.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/pages/auth/statusAuth.dart';
import 'package:message/services/auth.dart';
import 'package:message/widgets/PasswordFiledForm.dart';
import 'package:message/widgets/myTextFieldForm.dart';

class RegisterScreen extends StatefulWidget {
  AuthServices? authServices;
  RegisterScreen({required this.authServices});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Déclarations des variables
  AuthServices? authServices;
  String? pseudo, email,contact, status, mot_de_passe, confirmation_mot_de_passe;
  bool visibilite = true;
  bool c_visibilite = true;

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Image(image: AssetImage("assets/logo.jpg"), width: 150),
                    Text("Club Chat", style: style.copyWith(color: Colors.lightBlue, fontSize: 25)),
                    SizedBox(height: 50,),
                    MyTextFieldForm(name: "Pseudo",
                        edit: false,
                        value: "",
                        onChanged: () => (value) => {
                          setState(() {
                            pseudo = value;
                          })
                        },
                        validator:() => (value){
                          if(value == ""){
                            return "Veuillez saisir votre pseudo!";
                          }else if(value!.length < 6){
                            return "Votre pseudo doit avoir au moins 6 caractères!";
                          }
                        },
                        iconData: Icons.account_circle_outlined,
                        textInputType: TextInputType.name),
                    SizedBox(height: 10,),
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
                        iconData: Icons.email_outlined,
                        textInputType: TextInputType.emailAddress),
                    SizedBox(height: 10,),
                    // Contact
                    MyTextFieldForm(
                        edit: false,
                        value: "",
                        name: "Contact",
                        onChanged: () => (value) => {
                          setState(() {
                            contact = value;
                          })
                        },
                        validator: () => (value){
                          if(value == null || value.isEmpty){
                            return "Veuillez saisir votre contact";
                          }else if(value!.length != 10){
                            return "Votre numéro doit-être composé de 10 chiffres!";
                          }else if(!verifierPrefixNumeroTelephone(value)){
                            return "Votre numéro n'est pas valide!";
                          }
                        },
                        iconData: Icons.phone_outlined,
                        textInputType: TextInputType.phone),
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
                    // Confirmer votre mot de passe
                    PasswordFieldForm(
                        visibility: c_visibilite,
                        validator: () => (value){
                          if(value == "" || value.isEmpty){
                            return "Veuillez confirmer votre mot de passe!";
                          }else if(value != mot_de_passe){
                            return "Mot de passe ne correspond pas!";
                          }
                        },
                        name: "Confirmer votre mot de passe",
                        onTap: () => (){
                          setState(() {
                            c_visibilite = !c_visibilite;
                          });
                          print("${c_visibilite}");
                        },
                        onChanged: () => (value) => {
                          setState(() {
                            confirmation_mot_de_passe = value;
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
                          onPressed: () async {
                            if(_key.currentState!.validate()){
                              loading(context);
                              print(email! + " " + mot_de_passe!);
                              bool register = await authServices!.signup(email: email!, pseudo: pseudo!, pass: mot_de_passe!, contact: contact!, status: "0");
                              if(register != null){
                                Navigator.pop(context);
                                if(register) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => StatusAuthScreen()), (route) => false);
                              }
                            }else{
                              print("Non");
                            }
                          }, child: Text("S'inscrire", style: style.copyWith(color: Colors.white),)),
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
              Text("J'ai déjà un compte!", style: style.copyWith(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return LoginScreen(authServices: authServices,);
                  }), (route) => false);
                },
                child: Text("se connecter", style: style.copyWith(color: Colors.lightBlue)),
              )
            ]),
      ),
    );
  }
}
