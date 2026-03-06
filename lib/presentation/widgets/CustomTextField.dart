import 'package:flutter/material.dart';

import '../../app/resources/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final int maxLines;
  final TextEditingController controller;
  final String? inputData; // Nullable initial value
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.maxLines = 1,
    required this.controller,
    this.inputData, // Nullable initial value
    this.suffixIcon,
    this.onSuffixTap,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.obscureText,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Default password visibility is hidden

  @override
  void initState() {
    super.initState();
    if (widget.inputData != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.inputData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if it's a password field
    bool isPasswordField = widget.hint.toLowerCase().contains('password');

    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      style: TextStyle(fontFamily: 'Metropolis', fontSize: 14),
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      keyboardType: widget.keyboardType ??
          (isPasswordField
              ? TextInputType.visiblePassword
              : (widget.hint.toLowerCase().contains('cost'))
                  ? TextInputType.number
                  : TextInputType.text),
      obscureText: widget.obscureText ?? (isPasswordField ? _obscureText : false),
      // Toggle visibility for password
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: widget.hint,
        labelStyle: TextStyle(color: AppColors.black, fontFamily: 'Metropolis'),
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1.5),
        ),
        suffixIcon: isPasswordField
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle password visibility
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.black,
          ),
        )
            : widget.suffixIcon != null
            ? GestureDetector(
          onTap: widget.onSuffixTap,
          child: widget.suffixIcon,
        )
            : null,
      ),
    );
  }
}