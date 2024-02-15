import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message/model/User.dart';
import 'package:path/path.dart' as Path;

class DbServices{

  final CollectionReference userCol = FirebaseFirestore.instance.collection("users");

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

  // Future<String?> uploadImage(File file, {String? path}) async{
  //   var time = DateTime.now().toString();
  //   var ext = Path.basename(file.path).split(".")[1].toString();
  //   String image = path! + "_" + time + "." + ext;
  //   try{
  //     Reference ref = FirebaseStorage.instance.ref().child(path! + "/" + image);
  //     UploadTask uploadTask = ref.putFile(file);
  //     return await uploadTask.then((res) => res.ref.getDownloadURL());
  //   }catch(e){
  //     return null;
  //   }
  // }
}