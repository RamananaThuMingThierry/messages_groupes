import 'package:firebase_auth/firebase_auth.dart';
import 'package:message/model/User.dart';
import 'package:message/services/db.dart';

class AuthServices{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signinAnomimous() async{

    try{
      final result = await auth.signInAnonymously();
      return result.user;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future signOut() async{
    try{
      return auth.signOut();
    }catch(e){
      return null;
    }
  }

  Future<bool> signup(String email, String pass, String pseudo) async{
    try{
      final result = await auth.createUserWithEmailAndPassword(email: email, password: pass);
      if(result.user != null){
        await DbServices().saveUser(UserModel(id: result.user!.uid, email: email, pseudo: pseudo));
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> signin(String email, String pass) async{
    try{
      final result = await auth.signInWithEmailAndPassword(email: email, password: pass);
      if(result != null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> validationPassword(String password) async{
    var firebaseUser = await auth.currentUser;
    var authCredential = EmailAuthProvider.credential(email: firebaseUser!.email!, password: password);
    try{
      var authResultat = await firebaseUser.reauthenticateWithCredential(authCredential);
      return authResultat!.user! != null;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> updatePassword(String email, String password) async{
    try{
      final result =  auth.currentUser!.updatePassword(password);
      if(result != null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<User?> get user async{
    // Envoyer l'utilisateur connecter.
    final user = await FirebaseAuth.instance.currentUser;
    return user;
  }

}