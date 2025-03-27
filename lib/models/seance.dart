class SeanceModel {
  late int duree;
  late String idCours;
  late String date ;

  SeanceModel({
    required this.duree,
    required this.idCours,
    required this.date
  });

  SeanceModel.fromJson(Map<String, dynamic> json) {
    duree = json['duree'];
    idCours = json['idCours'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['duree'] =  duree;
    data['idCours'] = idCours;
    data['date'] = date;
    return data;
  }


}
