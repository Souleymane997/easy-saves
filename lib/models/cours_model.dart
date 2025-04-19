class CoursModel {
  late String idUser ;
  late String titre;
  late int prix;
  late String numParent;
  late bool archive ;

  CoursModel({
    required this.idUser,
    required this.titre,
    required this.prix,
    required this.numParent,
    required this.archive
  });

CoursModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'] ;
    titre = json['titre'];
    prix= json['prix'];
    numParent = json['numParent'];
    archive = json['archive'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['idUser'] = idUser ;
    data['titre'] =  titre;
    data['prix'] = prix ;
    data['numParent'] = numParent ;
    data['archive'] = archive ;
    return data;
  }


}
