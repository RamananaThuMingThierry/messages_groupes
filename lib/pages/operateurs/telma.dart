import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Telma extends StatefulWidget {

  const Telma({Key? key}) : super(key: key);
  @override
  State<Telma> createState() => _TelmaState();

}

class _TelmaState extends State<Telma> {
  // Déclarations des variables
  String? message;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void sendBulkSMS(List<String> phoneNumbers, String message) async {
    String numbers = phoneNumbers.join(",");
    String smsUri = 'sms:$numbers?body=$message';

    if (await canLaunch(smsUri)) {
      await launch(smsUri);
    } else {
      print('Could not open SMS application.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Telma", style: style.copyWith(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.sim_card_outlined))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Card(
                    shape: Border(
                      //  bottom: BorderSide(color: Colors.orangeAccent, width: 2),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          Text("Nombres : ", style: style.copyWith(color: Colors.green),),
                          Text("Il n'y a aucun numéro", style: style.copyWith(color: Colors.black54),),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    elevation: 1,
                    shape: Border(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            enabled: true,
                            onChanged: (value){
                              setState(() {
                                message = value;
                              });
                            },
                            validator: (value){
                              if(value!.isEmpty){
                                return "Veuillez saisir votre message!";
                              }
                            },
                            style: TextStyle(color: Colors.blueGrey),
                            decoration: InputDecoration(
                              hintText: "Rédiger votre message",
                              suffixIcon: Icon(Icons.message_outlined),
                              hintStyle: TextStyle(color: Colors.blueGrey),
                              suffixIconColor: Colors.grey,
                              enabledBorder : OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              disabledBorder : OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red
                                  )
                              ),
                            ),
                            maxLines: 10,
                          ),
                          SizedBox(height: 5,),
                          //Button
                          InkWell(
                            onTap: () => validation(),
                            child: Container(
                              height: 40,
                              color: Colors.lightBlue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Envoyer", style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.send,color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      print("oui");
    }else{
      print("Non");
    }
  }
}
