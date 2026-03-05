import 'ItemsModel.dart';

class CategoryModel {
  final bool success;
  final List<Category> data;

  CategoryModel({
    required this.success,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?; // Check for null
    List<Category> categoryList = list != null
        ? list.map((i) => Category.fromJson(i)).toList()
        : []; // Default to empty list if data is null

    return CategoryModel(
      success: json['success'],
      data: categoryList,
    );
  }
}
