import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/fonctions.dart';
import 'package:message/fonctions/loading.dart';
import 'package:message/model/Personne.dart';
import 'package:message/services/auth.dart';
import 'package:message/services/db.dart';
import 'package:message/widgets/ligne_horizontale.dart';
import 'package:message/widgets/myTextFieldForm.dart';

class AddContact extends StatefulWidget {
  AuthServices authServices;
  AddContact({required this.authServices});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  AuthServices? authServices;

  String? image;
  String? nom;
  String? contact;
  File? imageFiles;
  CroppedFile? croppedImage;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    authServices = widget.authServices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Informations",  style: style.copyWith(fontSize: 18, color: Colors.lightBlue),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.lightBlue,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.contact_phone_outlined, color: Colors.lightBlue,))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              (croppedImage != null) ? Image.file(File(croppedImage!.path)) : Image.asset("assets/no_image.jpg"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () => getImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt_outlined, color: Colors.black,)
                  ),
                  IconButton(
                      onPressed: () => getImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library_outlined, color: Colors.greenAccent,)
                  ),
                ],
              ),
              Ligne(color: Colors.blueGrey),
              Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      MyTextFieldForm(
                          name: "Nom",
                          onChanged: () => (value){
                            setState(() {
                              nom = value;
                            });
                          },
                          validator: () => (value){
                            if(value == null || value.isEmpty){
                              return "Veuillez saisir votre nom";
                            }
                          },
                          iconData: Icons.person,
                          textInputType: TextInputType.text,
                          edit: false,
                          value: ""),
                      MyTextFieldForm(
                          name: "Contact",
                          onChanged: () => (value){
                            setState(() {
                              contact = value;
                            });
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
                          textInputType: TextInputType.number,
                          edit: false,
                          value: ""),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if(_key.currentState!.validate()){
                              loading(context);
                              Personne personne = Personne();
                              int? uid = await DbServices().obtenirDernierId();
                              print("-------------------------- uid  $uid ----------------------------");
                              personne.id = uid.toString();
                              personne.nom = nom;
                              personne.contact = contact;
                              if(image != null){
                                String? imageURL = await DbServices().uploadImage(File(image!), path: "personnes");
                                if(imageURL != null){
                                  personne.image = imageURL;
                                }
                              }
                              bool savePersonne = await DbServices().savePersonnes(personne);
                              if(savePersonne){
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showAlertDialog(context, "Success", "Enregistrement réussi!");
                              }else{
                                showAlertDialog(context, "Warning", "Erreur d'enregistrement!");
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          child: Text("Enregistre", style: style.copyWith(color: Colors.white),),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async{
    final newImage = await ImagePicker().pickImage(source: source);
    if(newImage != null){
      final File image = File(newImage!.path);
      cropImage(image); // Call the image cropping function
    }
  }

  Future cropImage(File imageR) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageR.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Recadrez l\'image',
            toolbarColor: Colors.lightBlue,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.lightBlue,
            hideBottomControls: false,
            cropGridColumnCount: 3,
            cropGridRowCount: 3,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        croppedImage = croppedFile;
        image = croppedFile.path;
        imageFiles = File(croppedFile!.path);
      });
    }
  }
}
