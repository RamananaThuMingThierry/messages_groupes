import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';

bool verifierPrefixNumeroTelephone(String numeroTelephone){
  RegExp regex = RegExp(r'^(032|033|034|038)');
  return regex.hasMatch(numeroTelephone);
}


void ContactezNous({String? numero, String? action}) async {
  final Uri url = Uri(
      scheme: action,
      path: numero
  );
  if(await canLaunchUrl(url)){
    await launchUrl(url);
  }else{
    print("${url}");
  }
}

void ActionsCallOrMessage(BuildContext context, String? numero){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 50),
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                      ContactezNous(numero: numero, action: "tel");
                    },
                    icon: Icon(Icons.call_outlined, color: Colors.blue,),
                    label: Text("Appeler", style: style.copyWith(fontWeight: FontWeight.w500),)),
                Container(
                  color: Colors.grey,
                  width: .5,
                  height: 25,
                ),
                TextButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                      ContactezNous(numero: numero, action: "sms");
                    },
                    icon: Icon(Icons.sms_outlined, color: Colors.lightBlue,),
                    label: Text("Message", style: style.copyWith(fontWeight: FontWeight.w500),)),
              ],
            ),
          ),
        );
      });
}


void deconnectionAlertDialog(BuildContext context, AuthServices authServices){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 70,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Vous déconnecter de votre compte?", textAlign: TextAlign.center, style: style.copyWith(fontSize: 18),),
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  print("Annuler");
                },
                child: Text("Annuler", style: style.copyWith(color: Colors.lightBlue),)),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  onLoadingDeconnection(context, authServices);
                }, child: Text("Se déconnecter",style: style.copyWith(color: Colors.redAccent))),
          ],
        );
      });
}

void onLoadingDeconnection(BuildContext context, AuthServices authServices){
  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          await authServices!.signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => LoginScreen(authServices: authServices)), (route) => false);
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blueGrey,),
                SizedBox(height: 16,),
                Text("Déconnection...", style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
        );
      });
}

void showAlertDialogAbout(BuildContext context){
  showAboutDialog(
      context: context,
      applicationName: "Club Chat",
      applicationVersion: "1.3.2",
      applicationIcon: Icon(Icons.info_outlined, color: Colors.lightBlue,),
      applicationLegalese: "copyright @2023 Vision-Dev",
      children: [
        SizedBox(height: 10,),
        Text("Club chat a pour but de faciler l'envoyer d'un message à plusieurs personnes en une seul fois.", style: style.copyWith(color: Colors.grey),),
      ]
  );
}