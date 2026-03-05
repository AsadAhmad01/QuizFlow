import 'package:RoseAI/app/utils/app_constants.dart';
import 'package:RoseAI/app/utils/shared_prefs_helper.dart';
import 'package:RoseAI/presentation/widgets/ActionButtonWidget.dart';
import 'package:RoseAI/presentation/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DeleteAccountDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext alertContext) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Delete Account",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            // Description
            Text(
              "Are you sure you want to delete your account?\nThis action is irreversible. Your account and all associated data, including profile information, items history, and lent details, will be permanently deleted.\nPlease note that this process cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),

            // Email Display
            Text(
              AppConstants.userModel!.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.redAccent,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30),

            // Password Field
            if(AppConstants.userModel!.isPasswordVerified)
            Form(
              key: _formKey,
              child: CustomTextField(
                hint: "Enter Password",
                controller: controller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  } else if (SharedPrefsHelper.getPassword() != value) {
                    return "Incorrect Password";
                  }
                  return null; // No validation error
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        // Confirm Button
        ActionButtonWidget(
          onPressed: () {
            if(AppConstants.userModel!.isPasswordVerified){
              if (_formKey.currentState!.validate()) {
                final pass = SharedPrefsHelper.getPassword();
                if (pass == controller.text) {
                  onConfirm();
                  Navigator.pop(alertContext);
                } else {}
              }
            }else{
              onConfirm();
              Navigator.pop(alertContext);
            }
          },
          isLoading: false,
          text: 'Confirm',
        ),
      ],
    );
  }

  // Method to show the Delete Account Dialog
  static void show(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog(onConfirm: onConfirm);
      },
    );
  }
}
