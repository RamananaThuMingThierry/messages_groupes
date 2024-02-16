import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:message/model/Personne.dart';
import 'package:message/model/User.dart';
import 'package:path/path.dart' as Path;

class DbServices{

  final CollectionReference userCol = FirebaseFirestore.instance.collection("users");
  final CollectionReference personneCol = FirebaseFirestore.instance.collection("personnes");

  Future<UserModel?> getUser(String id) async{
    final donne = await userCol.doc(id).get();
    final user = UserModel.fromJson(donne.data() as Map<String, dynamic>);
    if(user == null){
      return null;
    }else{
      return user;
    }
  }

  Stream<List<UserModel>> get getUsers{
    return userCol.orderBy('pseudo').snapshots().map((user){
      return user.docs.map((e) {
        return UserModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  Future saveUser(UserModel user) async{
    try{
      await userCol.doc(user.id).set(user.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

    Future<bool> updateUser(UserModel userM) async{
    try{
      await userCol.doc(userM.id).update(userM.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  // Obtenez le dernier ID de document pour les articles
  Future<int> obtenirDernierId() async {
    QuerySnapshot querySnapshot = await personneCol.orderBy('id', descending: true).limit(1).get();
    int lastId = 0;
    print(querySnapshot.docs.isNotEmpty);
    if (querySnapshot.docs.isNotEmpty) {
      lastId = int.parse(querySnapshot.docs.first['id']) + 1;
    }
    return lastId;
  }

  Stream<List<Personne>> get getPersonne{
    return personneCol.orderBy('nom').snapshots().map((personne){
      return personne.docs.map((e) {
        return Personne.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future savePersonnes(Personne personne) async{
    try{
      await personneCol.doc(personne.id).set(personne.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future updatePersonnes(Personne personne) async{
    try{
      await personneCol.doc(personne.id).update(personne.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future<String?> uploadImage(File file, {String? path}) async{
    var time = DateTime.now().toString();
    var ext = Path.basename(file.path).split(".")[1].toString();
    String image = path! + "_" + time + "." + ext;
    try{
      Reference ref = FirebaseStorage.instance.ref().child(path! + "/" + image);
      UploadTask uploadTask = ref.putFile(file);
      return await uploadTask.then((res) => res.ref.getDownloadURL());
    }catch(e){
      return null;
    }
  }
}