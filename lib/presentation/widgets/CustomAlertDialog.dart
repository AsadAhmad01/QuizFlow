import 'package:RoseAI/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog {
  static void showAlertDialog(
      BuildContext context,
      String title,
      String message,
      VoidCallback onOkPressed, // Listener for the OK button
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onOkPressed(); // Trigger the listener callback
              },
              child: Center(
                child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.btnColor,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
