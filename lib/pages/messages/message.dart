import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message/class/Drawer.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/fonctions.dart';
import 'package:message/fonctions/loadingShimmer.dart';
import 'package:message/model/Personne.dart';
import 'package:message/model/User.dart';
import 'package:message/pages/auth/login.dart';
import 'package:message/pages/auth/statusAuth.dart';
import 'package:message/pages/contacts/addContact.dart';
import 'package:message/pages/contacts/updateContact.dart';
import 'package:message/pages/profiles/profile.dart';
import 'package:message/pages/sim/sim.dart';
import 'package:message/pages/utilisateurs/users.dart';
import 'package:message/pages/utilisateurs/valideUserEnAtttente.dart';
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
  List<Personne> _listPersonnes = [];

  getPersonnesStream() async{
    var data = await FirebaseFirestore.instance.collection("personnes").orderBy("nom").get();
    setState(() {
      _listPersonnes = data.docs.map((e) {
        return Personne.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  AuthServices? authServices;
  @override
  void initState() {
    user = widget.user;
    authServices = widget.authServices;
    getPersonnesStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.lightBlue,),),
        backgroundColor: Colors.white,
        elevation: .5,
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
                title: Text("Profile", style: style,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (ctx) => Profile(user: user!)));
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.message_outlined, color: Colors.blueGrey,),
                title: Text("Message Groupe", style: style,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => MessagesGroupes()));
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.people_outline, color: Colors.blueGrey,),
                title: Text("Utilisateurs", style: style,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => UtilisateursScreen()));
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.confirmation_number_outlined, color: Colors.blueGrey,),
                title: Text("En attente", style: style,),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => UsersEnAtttenteScreen()));
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.info_outlined, color: Colors.blueGrey,),
                title: Text("Apropos", style: style,),
                onTap: (){
                  _key.currentState!.openEndDrawer();
                  showAlertDialogAbout(context);
                },
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.blueGrey,),
                title: Text("Déconnection", style: style,),
                onTap: () async{
                  Navigator.pop(context);
                  deconnectionAlertDialog(context, authServices!);
                },
              ),
              Ligne(color: Colors.grey,),
            ],
          ),
        ),
      ),
      body: _listPersonnes == null
          ? LoadingShimmer()
          : RefreshIndicator(
            onRefresh: () => getPersonnesStream(),
            child: _listPersonnes.length == 0
                ? Center(
                    child: Text("Aucun résultat", style: style.copyWith(color: Colors.lightBlue),),
                )
                : ListView.builder(
                  itemCount: _listPersonnes.length,
                  itemBuilder: (context, index){
                    Personne personne = _listPersonnes[index];
                    return GestureDetector(
                      onLongPress: () => ActionsCallOrMessage(context, personne.contact),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2,),
                          child: Card(
                            shape: Border(),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                leading: personne.image == null
                                    ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage("assets/photo.png"))
                                    : CircleAvatar(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                                              errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                                              imageUrl: personne.image!),
                                        ),
                                      )
                                ,
                                title: Text("${personne.nom}", style: style.copyWith(color: Colors.blueGrey),),
                                subtitle: Text("${personne.contact}", style: style.copyWith(color: Colors.grey),),
                                trailing: PopupMenuButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.more_vert, color: Colors.black,),
                                  ),
                                  onSelected: (valeur){
                                    if(valeur == "Modifier"){
                                      // Modifier
                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => UpdateContact(personne: personne, authServices: authServices!)));
                                      print("Modifier");
                                    }else{
                                      // Supprimer
                                      print("Supprimer");
                                    }
                                  },
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                      value: "Modifier",
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.lightBlue,),
                                          SizedBox(width: 10,),
                                          Text("Modifier", style: style.copyWith(color: Colors.lightBlue)),
                                        ]
                                        ,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red,),
                                          SizedBox(width: 10,),
                                          Text("Supprimer", style: style.copyWith(color: Colors.red)),
                                        ]
                                        ,
                                      ),
                                      value: "Supprimer",
                                    )
                                  ],
                                )
                              ),
                            ),
                          ),
                      ),
                    );
                  })
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddContact(authServices: authServices!,))),
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
