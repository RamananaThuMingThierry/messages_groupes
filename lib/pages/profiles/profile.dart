import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';
import 'package:message/fonctions/fonctions.dart';
import 'package:message/model/User.dart';

class Profile extends StatefulWidget {
  UserModel user;
  Profile({required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              coverImage: user!.image == null ? AssetImage("assets/photo.png") : NetworkImage(user!.image!) as ImageProvider,
              avatar: user!.image == null ? AssetImage("assets/photo.png") : NetworkImage(user!.image!) as ImageProvider,
              title: user!.pseudo!,
            ),
            SizedBox(height: 10,),
            UserInfo(users: user,)
          ],
        ),
      ),
    );
  }
}


class ProfileHeader extends StatelessWidget{
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic>? avatar;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  ProfileHeader({
    Key? key,
    required this.coverImage,
    this.avatar,
    required this.title,
    this.subtitle,
    this.actions
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Ink(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: coverImage as ImageProvider,
                  fit: BoxFit.cover
              )
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.black38
          ),
        ),
        if(actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(bottom: 0, right: 0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Avatar(
                image: avatar as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWith: 4,
              ),
              SizedBox(height: 15,),
              Text(
                  title,
                  style: style.copyWith(color: Colors.blueGrey, fontSize: 17)
              ),
              if(subtitle != null)...[
                SizedBox(height: 5,),
                Text(
                  subtitle!,
                  style: style,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}

class Avatar extends StatelessWidget{
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWith;

  Avatar({
    Key? key,
    required this.image,
    this.backgroundColor,
    this.radius = 30,
    this.borderWith = 5,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWith,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blueGrey,
        child: CircleAvatar(
          radius: radius - borderWith,
          backgroundImage: image as ImageProvider,
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget{
  UserModel? users;
  UserInfo({this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            shape: Border(),
            elevation: 1,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  ...ListTile.divideTiles(
                      color: Colors.blueGrey,
                      tiles: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2
                          ),
                          title: Text("Pseudo", style: style.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.pseudo}", style: style.copyWith(color: Colors.grey),),
                          leading: Icon(Icons.account_circle_outlined, color: Colors.lightBlue,),
                        ),ListTile(
                          leading: Icon(Icons.mail_outline, color: Colors.lightBlue,),
                          title: Text("Adresse e-mail", style: style.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.email}", style: style.copyWith(color: Colors.grey),),
                        ),
                        ListTile(
                          onTap: () => ActionsCallOrMessage(context, users!.contact),
                          leading: Icon(Icons.call_outlined, color: Colors.lightBlue,),
                          title: Text("Contact", style: style.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.contact ?? '-'}", style: style.copyWith(color: Colors.grey),),
                        ),
                        ListTile(
                          leading: Icon(users!.status == 0 ? Icons.disabled_by_default_outlined :  Icons.check_box, color: Colors.lightBlue,),
                          title: Text("Status", style: style.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.status == 0 ? "En attente" : "Valide"}", style: style.copyWith(color: Colors.grey),),
                        )
                      ])
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                ),
                onPressed: (){},
                child: Text("Modifer", style: style.copyWith(color: Colors.white),),
              ),
            ),
          )
        ],
      ),
    );
  }

}