import 'package:flutter/material.dart';
import '../../data/models/quiz/quiz_models.dart';

class UserSessionProvider extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoggedIn = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  void login(String email) {
    _currentUser = UserProfile(
      name: 'Alex Johnson',
      email: email,
      imageUrl:
          'https://api.dicebear.com/7.x/avataaars/png?seed=quiz&backgroundColor=b6e3f4',
      rank: 3,
      score: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  void addScore(int points) {
    if (_currentUser != null) {
      _currentUser!.score += points;
      if (_currentUser!.score >= 500) {
        _currentUser!.rank = 1;
      } else if (_currentUser!.score >= 300) {
        _currentUser!.rank = 2;
      } else if (_currentUser!.score >= 100) {
        _currentUser!.rank = 3;
      } else {
        _currentUser!.rank = 5;
      }
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
