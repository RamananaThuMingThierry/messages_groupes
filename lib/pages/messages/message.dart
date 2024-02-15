import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message/class/Drawer.dart';
import 'package:message/constants/constants.dart';
import 'package:message/model/User.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/pages/auth/statusAuth.dart';
import 'package:message/services/auth.dart';
import 'package:message/widgets/ligne_horizontale.dart';

class MessageScreen extends StatefulWidget {
  UserModel? user;
  AuthServices authServices;
  MessageScreen({required this.user, required this.authServices});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  UserModel? user;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AuthServices? authServices;
  @override
  void initState() {
    user = widget.user;
    authServices = widget.authServices;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.lightBlue,),),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Club Chat", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.lightBlue),),
        actions: [
          IconButton(onPressed: (){},icon: Icon(Icons.chat_outlined, color: Colors.lightBlue,),),
        ],
      ),
      drawer:  ClipPath(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          width: 275.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey, // Couleur de fond par défaut
                  child: user!.image != null
                      ? CachedNetworkImage(
                    imageUrl: user!.image!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                      : Icon(Icons.person), // Widget par défaut si imageUrl est null
                ),
                // backgroundImage: (userm!.image == null) ? Image.asset("assets/photo.png").image : Image.network(userm!.image!).image
                accountName: Text("${user!.pseudo ?? "Aucun"}", style: style.copyWith(color: Colors.white)),
                accountEmail: Text("${user!.email ?? "Aucun"}", overflow: TextOverflow.ellipsis, style: style.copyWith(color: Colors.white)),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/no_image.jpg"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined, color: Colors.blueGrey,),
                title: Text("Accueil", style: style,),
                onTap: () => Navigator.pop(context),
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.person_2_outlined, color: Colors.blueGrey,),
                title: Text("Profiles", style: style,),
                onTap: (){
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.info_outlined, color: Colors.blueGrey,),
                title: Text("Apropos", style: style,),
                onTap: (){
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.blueGrey,),
                title: Text("Déconnection", style: style,),
                onTap: () async{
                  Navigator.pop(context);
                  await authServices!.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => LoginScreen(authServices: authServices)), (route) => false);
                },
              ),
              Ligne(color: Colors.grey,),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenu"),
            Text("Pseudo : ${user!.pseudo}"),
            Text("Uid : ${user!.id}"),
            Text("email : ${user!.email}")
          ],
        ),
      ),
    );
  }
}
