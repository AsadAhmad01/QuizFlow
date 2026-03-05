class FormValidator {
  // Private constructor
  FormValidator._();

  // Singleton instance
  static final FormValidator instance = FormValidator._();

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return "Item Title is required";
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Item Description is required";
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Item Location is required";
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Item Category is required";
    }
    return null;
  }

  String? validateCost(String? value) {
    if (value == null || value.trim().isEmpty) return "Item Cost is required";
    return null;
  }

  String? validateDateOfPurchase(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Item Purchase Date is required";
    }
    return null;
  }

  String? validateDateOfExpiryWarranty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Item's Warranty date is required";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required";

    final nameRegExp = RegExp(r"^[A-Za-z\s\-\.’']+$");
    if (!nameRegExp.hasMatch(value)) {
      return 'Only accept letters, spaces, hyphens, apostrophes, and periods';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    // Regex: allows digits, spaces, parentheses, hyphens, and plus signs (7–15 chars)
    final phoneRegex = RegExp(r'^[0-9+\-() ]{7,15}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return "Enter a valid phone number (7–15 digits, may include +, -, (), space)";
    }

    return null; // valid
  }


  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";

    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) return "Enter a valid email";

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";

    if (value.length < 8) return "Password must be at least 8 characters";

    if (value.length > 20) return "Password must not exceed 20 characters";

    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Password must contain at least 1 uppercase letter";

    if (!RegExp(r'[a-z]').hasMatch(value)) return "Password must contain at least 1 lowercase letter";

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return "Password must contain at least 1 special character";

    if (!RegExp(r'[0-9]').hasMatch(value)) return "Password must contain at least 1 number";

    return null;
  }


  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm your password";
    }
    if (confirmPassword != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
