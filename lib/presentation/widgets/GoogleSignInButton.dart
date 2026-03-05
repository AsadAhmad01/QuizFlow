import 'package:RoseAI/app/resources/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading; // Flag to check if loading

  GoogleSignInButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child:SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed, // Disable button during loading
            icon: SizedBox(
              width: 24.0, // Fixed width for both states
              height: 24.0, // Fixed height for both states
              child: isLoading
                  ? CircularProgressIndicator(
                color: Colors.white, // White color for the loader
                strokeWidth: 2,
              )
                  : Image.asset(
                'assets/images/search.png', // Google logo image
                width: 24.0, // Fixed size for the icon
                height: 24.0,
              ),
            ),
            label: isLoading
                ? SizedBox() // Empty space when loading (to hide the text)
                : Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for the text
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Background color (remains black)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 16.0),
            ),
          ),
        )
      ),
    );
  }
}