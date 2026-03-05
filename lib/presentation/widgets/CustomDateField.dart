import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:RoseAI/app/resources/app_colors.dart';

class CustomDateField extends StatefulWidget {
  final String hint;
  final String? inputData; // Optional initial value
  final TextEditingController controller;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  const CustomDateField({
    Key? key,
    required this.hint, // Changed from hint to label
    required this.controller,
    this.inputData, // Null by default
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  void initState() {
    super.initState();

    if (widget.inputData != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.inputData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onTap: widget.onTap,
      style: const TextStyle(fontFamily: 'Metropolis', fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.hint,
        // Using labelText for floating effect
        labelStyle: TextStyle(color: AppColors.black, fontFamily: 'Metropolis'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 2.0),
        ),
        filled: true,
        fillColor: AppColors.white,
        suffixIcon: SvgPicture.asset(
          'assets/icons/calendar.svg',
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
