import 'package:RoseAI/data/models/signup_resp_model.dart';
import 'package:RoseAI/domain/usecase/parse_health_data_usecase.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/usecase/LoginUser_usecase.dart';
import '../bloc/auth_state.dart';

class AuthViewModel with ChangeNotifier {
  final LoginUser loginUser;
  final ParseHealthDataUseCase parseHealthData;

  AuthState _state = AuthInitial();

  AuthState get state => _state;

  AuthViewModel({required this.loginUser, required this.parseHealthData});

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

  Future<void> parseHealthDataToServer(Map<String, dynamic> data) async {
    _state = AuthLoading();
    notifyListeners();

    try {
      final RegisterResponse user = await parseHealthData(data);
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
