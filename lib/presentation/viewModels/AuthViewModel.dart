import 'package:flutter/cupertino.dart';

import '../../data/models/signup_resp_model.dart';
import '../../domain/usecase/LoginUser_usecase.dart';
import '../bloc/auth_state.dart';

class AuthViewModel with ChangeNotifier {
  final LoginUser loginUser;

  AuthState _state = AuthInitial();
  AuthState get state => _state;

  AuthViewModel({required this.loginUser});

  Future<void> login(Map<String, dynamic> data) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      final RegisterResponse user = await loginUser(data);
      if (user.success) {
        _state = AuthSuccess(user);
      } else {
        _state = AuthFailure(user.message);
      }
    } catch (e) {
      _state = AuthFailure(e.toString());
    }
    notifyListeners();
  }

  void resetState() {
    _state = AuthInitial();
    notifyListeners();
  }
}
