import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/fonctions.dart';
import 'package:message/model/Personne.dart';
import 'package:message/services/auth.dart';
import 'package:message/widgets/ligne_horizontale.dart';
import 'package:message/widgets/myTextFieldForm.dart';

class UpdateContact extends StatefulWidget {
  AuthServices authServices;
  Personne personne;
  UpdateContact({required this.personne, required this.authServices});

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  Personne? personne;
  AuthServices? authServices;
  String? image;
  bool? image_existe;
  String? image_update;
  String? nom;
  String? contact;
  File? imageFiles;
  CroppedFile? croppedImage;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    personne = widget.personne;
    nom = personne!.nom;
    contact = personne!.contact;
    image_existe = personne!.image == null ? false : true;
    image_update = personne!.image;
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
        title: Text("Modification",  style: style.copyWith(fontSize: 18, color: Colors.lightBlue),),
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
              (image_existe == false)
                   ?  Image.asset("assets/no_image.jpg")
                   : (image_update != null)
                        ? Container(
                            child:  CachedNetworkImage(
                              imageUrl: image_update!,
                              placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                              errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                            ),
                          )
                        : (croppedImage != null) ? Image.file(File(croppedImage!.path)) : Image.asset("assets/no_image.jpg"),
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
                          edit: true,
                          value: nom!),
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
                          edit: true,
                          value: contact!),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if(_key.currentState!.validate()){

                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          child: Text("Modifier", style: style.copyWith(color: Colors.white),),
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
            toolbarTitle: 'Recadrer l\'image',
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
        image_existe = true;
        image_update = null;
      });
    }
  }
}
