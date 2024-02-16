class Personne{
  String? id, nom, contact, image;

  Personne({this.id, this.nom, this.image, this.contact});

  static Personne? current;

  factory Personne.fromJson(Map<String, dynamic> j){
    return Personne(
        nom: j['nom'],
        contact: j['contact'],
        image: j['image'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom" : nom,
    "contact" : contact,
    "image": image
  };
}