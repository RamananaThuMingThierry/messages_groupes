import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
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