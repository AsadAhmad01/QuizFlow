import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/routes/app_router.gr.dart';
import '../../app/utils/app_constants.dart';
import '../../app/utils/shared_prefs_helper.dart';
import '../../presentation/viewModels/AuthViewModel.dart';
import '../models/ItemsModel.dart';
import 'dart:convert';

import '../models/lent_item_Model.dart'; // For json.encode() and json.decode

class Constant_fun {
  final storage = FlutterSecureStorage();

  Future<bool> saveUserData({
    required String userId,
    String? email,
    String? fullName,
  }) async {
    try {
      Map<String, dynamic> userData = {'email': email, 'fullName': fullName};
      String encodedData = json.encode(userData);
      await storage.write(key: userId, value: encodedData);
      print("saving user data");
      return true;
    } catch (e) {
      print("Error saving user data: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> readUserData(String userId) async {
    String? encodedData = await storage.read(key: userId);

    if (encodedData != null) {
      Map<String, dynamic> userData = json.decode(encodedData);
      return userData;
    } else {
      return {}; // Return an empty map if no data is found
    }
  }

  static String extractError(dynamic e) {
    if (e is DioException) {
      return e.response?.data.toString() ?? e.message ?? 'Unknown error';
    }
    return e.toString();
  }

  String formatDate(String isoDate) {
    DateTime date =
        DateTime.parse(
          isoDate,
        ).toLocal(); // parse and convert to local time if needed
    final formatter = DateFormat('yyyy-MMM-dd');
    return formatter.format(date);
  }

  static Category mapLocationToCategory(Location location) {
    return Category(
      id: location.id,
      name: location.name,
      description: location.description,
      image: location.image,
    );
  }

  static Location mapCategoryToLocation(Category category) {
    return Location(
      id: category.id,
      name: category.name,
      description: category.description,
      image: category.image,
      status: false,
      // default false since Category has no status
      v: 0,
      // default 0, no equivalent in Category
      createdBy: null,
      // null because Category has no createdBy
      createdAt: null,
      // null because Category has no createdAt
      updatedAt: null, // null because Category has no updatedAt
    );
  }

  static Future<void> selectDate(
    BuildContext context,
    TextEditingController controller, {
    bool isExpiryDate = true,
    required Function(String formattedDate) onDatePicked,
  }) async {
    DateTime initialDate = DateTime.now();

    // Try parsing existing date from controller text if valid
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
      } catch (_) {}
    }

    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = isExpiryDate ? DateTime(2100) : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          initialDate.isBefore(firstDate) || initialDate.isAfter(lastDate)
              ? DateTime.now()
              : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      onDatePicked(formatted);
    }
  }

  static Item mapItemDataToItem(
    ItemData itemData, {
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: itemData.id,
      name: itemData.name,
      description: itemData.description,
      image: itemData.image,
      receipt: itemData.receipt,
      location: itemData.location,
      category: itemData.category,
      createdBy: itemData.createdBy,
      purchaseCost: itemData.purchaseCost,
      // Assuming purchaseCost is int in ItemData
      purchaseDate:
          itemData.purchaseDate.isEmpty ? null : itemData.purchaseDate,
      expiryDate: itemData.expiryDate.isEmpty ? null : itemData.expiryDate,
      tags: itemData.tags,
      status: itemData.status,
      assignments: itemData.assignedUsers,
      // You can map the assignments here if necessary
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: 1, // Default version, you can adjust based on your requirements
    );
  }

  static void clearData() {
    AppConstants.userModel = null;
    AppConstants.commonItems = [];
    AppConstants.totalItemCount = 0;
    AppConstants.totalItemLentCount = 0;
    AppConstants.isHomeCalled = true;
    AppConstants.isItemCalled = true;
  }

  static String getFormattedValue(dynamic value) {
    if (value is int) {
      return value.toString(); // Return integer as string
    } else if (value is double) {
      return value.toStringAsFixed(
        2,
      ); // Format double to string with 2 decimal places
    } else if (value is String) {
      return value; // If it's already a string, return it as is
    } else {
      return ''; // Return an empty string if the value is not recognized
    }
  }

  static Future<void> performLogout(BuildContext context) async {
    try {
      await SharedPrefsHelper.removeUserData();
      Constant_fun.clearData();
      context.router.replaceAll([LoginRoute()]);
    } finally {}
  }
}
