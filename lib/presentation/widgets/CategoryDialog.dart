import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../app/utils/shared_prefs_helper.dart';

class CategoryDialog extends StatelessWidget {
  const CategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch categories from SharedPreferences
    final categories = SharedPrefsHelper.getCat_Loc("categories");

    return AlertDialog(
      title: const Text('Select Category'),
      content: SizedBox(
        height: double.maxFinite,
        // Set the height of the dialog
        width: double.maxFinite,
        // Set the width to take the full available space
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: SvgPicture.network(
                category.image,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
              title: Text(category.name),
              onTap: () {
                Navigator.pop(
                  context,
                  category,
                ); // Return the selected category
              },
            );
          },
        ),
      ),
    );
  }
}
