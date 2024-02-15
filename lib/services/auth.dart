import 'package:firebase_auth/firebase_auth.dart';

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

  Future<User?> get user async{
    // Envoyer l'utilisateur connecter.
    final user = await FirebaseAuth.instance.currentUser;
    return user;
  }

}