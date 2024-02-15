class UserModel{
  String? id, pseudo, email, image;
  UserModel({this.id, this.pseudo, this.email, this.image});

  static UserModel? current;

  factory UserModel.fromJson(Map<String, dynamic> j){
    return UserModel(
        email: j['email'],
        pseudo: j['pseudo'],
        image: j['image'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "pseudo" : pseudo,
    "email" : email,
    "image": image,
  };
}