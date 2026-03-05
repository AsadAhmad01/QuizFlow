import 'package:RoseAI/data/models/ItemsModel.dart';

class HomeModel<T> {
  final bool success;
  final String message;
  final T? data;

  HomeModel({
    required this.success,
    required this.message,
    this.data,
  });

  // Convert a JSON object to ApiResponse
  factory HomeModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonModel,
      ) {
    return HomeModel(
      success: json['success'] ?? false ,
      message: json['message']??'',
      data: json['data'] != null ? fromJsonModel(json['data']) : null,
    );
  }

  // Convert ApiResponse to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonModel) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonModel(data as T) : null,
    };
  }
}

class HomeData {
  final int totalItems;
  final int lentItems;
  final List<Item> recentItems;
  final List<LocationList> locations;

  HomeData({
    required this.totalItems,
    required this.lentItems,
    required this.recentItems,
    required this.locations,
  });

// Factory method to parse the JSON response into Data model
  factory HomeData.fromJson(Map<String, dynamic> json) {
    var recentItemsList = json['recentItems'] as List?;
    List<Item> recentItems = (recentItemsList != null && recentItemsList.isNotEmpty)
        ? recentItemsList.map((i) => Item.fromJson(i)).toList()
        : [];

    var locationsList = json['locations'] as List?;
    List<LocationList> locationsListData = (locationsList != null && locationsList.isNotEmpty)
        ? locationsList.map((i) => LocationList.fromJson(i)).toList()
        : [];


    return HomeData(
      totalItems: json['totalItems'] ?? 0,
      lentItems: json['lentItems'] ?? 0,
      recentItems: recentItems,
      locations: locationsListData,
    );
  }
}

class RecentItem {
  final String id;
  final String name;
  final String description;
  final List<String> image;
  final String receipt;
  final LocationObj location;
  final Category category;
  final String purchaseDate;
  final String expiryDate;
  final String createdAt;
  final String updatedAt;

  RecentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.receipt,
    required this.location,
    required this.category,
    required this.purchaseDate,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

// Factory method to parse the JSON response into RecentItem model
  factory RecentItem.fromJson(Map<String, dynamic> json) {
    var location = json['location'] != null
        ? LocationObj.fromJson(json['location'])
        : LocationObj( name: 'Unknown');
    var category = json['category'] != null
        ? Category.fromJson(json['category'])
        : Category(name: 'Unknown');

    return RecentItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: List<String>.from(json['image'] ?? []),
      receipt: json['receipt'] ?? '',
      location: location,
      category: category,
      purchaseDate: json['purchaseDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class LocationObj {
  final String name;

  LocationObj({ required this.name});

  // Factory method to parse the JSON response into Location model
  factory LocationObj.fromJson(Map<String, dynamic> json) {
    return LocationObj(
      name: json['name'] ?? 'Unknown',
    );
  }

}

class LocationList {
  final String id;
  final String name;
  final String image;

  LocationList({required this.id, required this.name, required this.image});

  // Factory method to parse the JSON response into Location model
  factory LocationList.fromJson(Map<String, dynamic> json) {
    return LocationList(
      id: json['_id'] ?? 'all', // Default id for 'view all locations'
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
    );
  }

}

class Category {
  final String name;

  Category({required this.name});

  // Factory method to parse the JSON response into Category model
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? 'Unknown');
  }
}

