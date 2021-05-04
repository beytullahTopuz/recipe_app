class Food {
  String foodId;
  String authorId;
  String foodName;
  List<String> foodMaterials;
  String recipe;
  String fotoUrl;

  Food(
      {this.foodId,
      this.authorId,
      this.foodName,
      this.foodMaterials,
      this.fotoUrl,
      this.recipe});

  Food.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    authorId = json['authorId'];
    foodName = json['foodName'];
    foodMaterials = json['foodMaterials'].cast<String>();
    recipe = json['recipe'];
    fotoUrl = json['fotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodId'] = this.foodId;
    data['authorId'] = this.authorId;
    data['foodName'] = this.foodName;
    data['foodMaterials'] = this.foodMaterials;
    data['recipe'] = this.recipe;
    data['fotoUrl'] = this.fotoUrl;
    return data;
  }
}
