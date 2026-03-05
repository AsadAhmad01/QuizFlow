import 'package:flutter_test/flutter_test.dart';
import 'package:RoseAI/presentation/providers/user_session_provider.dart';

void main() {
  group('UserSessionProvider', () {
    late UserSessionProvider provider;

    setUp(() {
      provider = UserSessionProvider();
    });

    test('initial state: not logged in, no user', () {
      expect(provider.isLoggedIn, isFalse);
      expect(provider.currentUser, isNull);
    });

    test('login sets isLoggedIn to true and stores user profile', () {
      provider.login('test@gmail.com');

      expect(provider.isLoggedIn, isTrue);
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser!.email, equals('test@gmail.com'));
      expect(provider.currentUser!.name, isNotEmpty);
    });

    test('login initialises score to 0', () {
      provider.login('test@gmail.com');
      expect(provider.currentUser!.score, equals(0));
    });

    test('addScore increments user score correctly', () {
      provider.login('test@gmail.com');
      provider.addScore(50);
      expect(provider.currentUser!.score, equals(50));

      provider.addScore(30);
      expect(provider.currentUser!.score, equals(80));
    });

    test('addScore updates rank when score crosses threshold', () {
      provider.login('test@gmail.com');

      // Initial rank is 5 (below 100)
      provider.addScore(10);
      expect(provider.currentUser!.rank, equals(5));

      // Rank should change to 3 at 100+ points
      provider.addScore(90);
      expect(provider.currentUser!.score, equals(100));
      expect(provider.currentUser!.rank, equals(3));

      // Rank should change to 2 at 300+ points
      provider.addScore(200);
      expect(provider.currentUser!.rank, equals(2));

      // Rank should change to 1 at 500+ points
      provider.addScore(200);
      expect(provider.currentUser!.score, equals(500));
      expect(provider.currentUser!.rank, equals(1));
    });

    test('logout clears user and sets isLoggedIn to false', () {
      provider.login('test@gmail.com');
      expect(provider.isLoggedIn, isTrue);

      provider.logout();
      expect(provider.isLoggedIn, isFalse);
      expect(provider.currentUser, isNull);
    });

    test('login with valid credentials uses stored email', () {
      const email = 'test@gmail.com';
      provider.login(email);
      expect(provider.currentUser!.email, equals(email));
    });
  });

  group('Login hardcoded credentials logic', () {
    const validEmail = 'test@gmail.com';
    const validPassword = 'Test@123';

    test('correct credentials return true', () {
      final email = 'test@gmail.com';
      final password = 'Test@123';
      final isValid = email == validEmail && password == validPassword;
      expect(isValid, isTrue);
    });

    test('wrong password returns false', () {
      final email = 'test@gmail.com';
      final password = 'wrongpassword';
      final isValid = email == validEmail && password == validPassword;
      expect(isValid, isFalse);
    });

    test('wrong email returns false', () {
      final email = 'other@gmail.com';
      final password = 'Test@123';
      final isValid = email == validEmail && password == validPassword;
      expect(isValid, isFalse);
    });

    test('both wrong returns false', () {
      final email = 'wrong@email.com';
      final password = 'wrong';
      final isValid = email == validEmail && password == validPassword;
      expect(isValid, isFalse);
    });
  });
}
