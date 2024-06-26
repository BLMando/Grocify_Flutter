import '../utils/utils.dart';

class CategoryModel {
  final String? id;
  final String? name;
  final String? image;

  CategoryModel({
    this.id,
    this.name,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: Utils.capitalizeFirstLetter(json['name']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': Utils.capitalizeFirstLetter(name as String),
      'image': image,
    };
  }
}
