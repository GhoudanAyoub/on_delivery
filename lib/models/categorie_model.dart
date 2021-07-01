class CategorieModel {
  String id;
  String name;
  String picture;

  CategorieModel({
    this.id,
    this.name,
    this.picture,
  });

  CategorieModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
  }
}
