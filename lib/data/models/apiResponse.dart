import 'package:RoseAI/data/models/ItemsModel.dart';

import '../utils/ConstantFunc.dart';
import 'lent_item_Model.dart';

class ApiResponse {
  final bool success;
  final ItemData data;
  final String message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json['success'] as bool,
    data: ItemData.fromJson(json['data'] as Map<String, dynamic>),
    message: json['message'] as String,
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.toJson(),
    'message': message,
  };
}

class ItemData {
  final String name;
  final String description;
  final List<String> image;
  final String receipt;
  final Location location;
  final Category category;
  final String createdBy;
  final String purchaseCost;
  final String purchaseDate;
  final String expiryDate;
  final List<String> tags;
  final String status;
  final String id;
  final List<AssignedUser> assignments;

  ItemData({
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
    required this.id,
    required this.assignments,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
    name: json['name'] as String? ?? '', // Null check for String
    description: json['description'] as String? ?? '', // Null check for String
    image: List<String>.from(json['image'] as List? ?? []), // Null check for List
    receipt: json['receipt'] as String? ?? '', // Null check for String
    location: json['location'] != null
        ? Location.fromJson(json['location'] as Map<String, dynamic>)
        : Location.empty(), // Null check for Location
    category: json['category'] != null
        ? Category.fromJson(json['category'] as Map<String, dynamic>)
        : Category.empty(), // Null check for Category
    createdBy: json['createdBy'] as String? ?? '', // Null check for String
    purchaseCost: Constant_fun.getFormattedValue(json['purchaseCost'] ?? ''), // Null check for String
    purchaseDate: json['purchaseDate'] as String? ?? '', // Null check for String
    expiryDate: json['expiryDate'] as String? ?? '', // Null check for String
    tags: List<String>.from(json['tags'] as List? ?? []), // Null check for List
    status: json['status'] as String? ?? '', // Null check for String
    id: json['_id'] as String? ?? '', // Null check for String
    assignments: json['assignedUsers'] != null
        ? (json['assignedUsers'] as List? ?? [])
        .map((e) => AssignedUser.fromJson(e as Map<String, dynamic>))
        .toList()
        : [], // Null check for List
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'image': image,
    'receipt': receipt,
    'location': location,
    'category': category,
    'createdBy': createdBy,
    'purchaseCost': purchaseCost,
    'purchaseDate': purchaseDate,
    'expiryDate': expiryDate,
    'tags': tags,
    'status': status,
    '_id': id,
    'assignments': assignments,
  };
}
