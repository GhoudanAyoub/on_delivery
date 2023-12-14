class CategorieModel {
  late String? id;
  late String? name;
 late String? picture;

  CategorieModel({
    required this.id,
    required this.name,
   required this.picture,
  });

  CategorieModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
  }
}
