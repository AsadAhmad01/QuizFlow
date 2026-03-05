import 'package:RoseAI/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;

  const ActionButtonWidget({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Metropolis',
                  ),
                ),
      ),
    );
  }
}
