import 'package:RoseAI/data/models/lent_item_Model.dart';
import 'package:RoseAI/data/utils/ConstantFunc.dart';

class ItemsModel {
  final bool success;
  int statusCode;
  final List<CategoryData> data;
  final List<Category> categories;
  final String message;

  ItemsModel({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.categories,
    required this.message,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      success: json['success'] ?? false,
      statusCode:  0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }
}

class CategoryData {
  final String id;
  final String name;
  final String image;
  final List<Item> items;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
    required this.items,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Item {
  final String id;
  final String name;
  final String description;
  final List<String> image;
  final String receipt;
  final Location location;
  final Category category;
  final String createdBy;
  final String purchaseCost;
  final String? purchaseDate;
  final String? expiryDate;
  final List<String> tags;
  final String status;
  final List<AssignedUser> assignments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.receipt,
    required this.location,
    required this.category,
    required this.createdBy,
    required this.purchaseCost,
    required this.purchaseDate,
    required this.expiryDate,
    required this.tags,
    required this.status,
    required this.assignments,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is int) return val.toDouble();
      if (val is double) return val;
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val);
      } catch (_) {
        return null;
      }
    }

    List<String> parseStringList(dynamic val) {
      if (val == null) return [];
      if (val is List) return val.map((e) => e.toString()).toList();
      return [];
    }

    return Item(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: parseStringList(json['image']),
      receipt: json['receipt'] ?? '',
      location:
          json['location'] != null
              ? Location.fromJson(json['location'])
              : Location.empty(),
      category:
          json['category'] != null
              ? Category.fromJson(json['category'])
              : Category.empty(),
      createdBy: json['createdBy'] ?? '',
      purchaseCost: Constant_fun.getFormattedValue(json['purchaseCost']),
      purchaseDate: json['purchaseDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      tags: List<String>.from(json['tags'] as List),
      status: json['status'] ?? '',
      assignments:
          json['assignedUsers'] != null
              ? (json['assignedUsers'] as List)
                  .map((e) => AssignedUser.fromJson(e))
                  .toList()
              : [],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      v: json['__v'] is int ? json['__v'] : 0,
    );
  }
}

class Location {
  final String id;
  final String name;
  final String description;
  final String image;
  final bool status;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      if (val is String) {
        return val.toLowerCase() == 'true';
      }
      return false;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val);
      } catch (_) {
        return null;
      }
    }

    return Location(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      status: parseBool(json['status']),
      createdBy: json['createdBy'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      v: json['__v'] is int ? json['__v'] : 0,
    );
  }

  factory Location.empty() {
    return Location(
      id: '',
      name: '',
      description: '',
      image: '',
      status: false,
      v: 0,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Category.empty() {
    return Category(id: '', name: '', description: '', image: '');
  }
}
