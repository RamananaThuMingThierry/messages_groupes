class UserModel{
  String? id, pseudo, email, image, contact, status;
  UserModel({this.id, this.pseudo, this.email, this.image, this.contact, this.status});

  static UserModel? current;

  factory UserModel.fromJson(Map<String, dynamic> j){
    return UserModel(
        email: j['email'],
        pseudo: j['pseudo'],
        image: j['image'],
        contact: j['contact'],
        status: j['status'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "pseudo" : pseudo,
    "email" : email,
    "image": image,
    "contact" : contact,
    "status" : status
  };
}