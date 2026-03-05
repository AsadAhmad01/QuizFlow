import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/resources/app_colors.dart';
import '../../app/routes/app_router.gr.dart';
import '../../app/utils/FormValidator.dart';
import '../providers/user_session_provider.dart';
import '../widgets/CustomTextField.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const _validEmail = 'test@gmail.com';
  static const _validPassword = 'Test@123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Simulate network delay for realism
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == _validEmail && password == _validPassword) {
      // Success — persist session in memory
      context.read<UserSessionProvider>().login(email);
      context.router.replaceAll([const MainRoute()]);
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Invalid email, please try again',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: isWide ? _buildWideLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Top logo area
        Container(
          height: 130,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'QuizFlow',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Text(
                'Learn. Quiz. Grow.',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: _buildFormContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Row(
          children: [
            // Left panel
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QuizFlow',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Learn. Quiz. Grow.',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _FeatureBullet(icon: Icons.quiz_rounded, text: 'Thousands of quiz questions'),
                    const SizedBox(height: 12),
                    _FeatureBullet(icon: Icons.leaderboard_rounded, text: 'Compete on the leaderboard'),
                    const SizedBox(height: 12),
                    _FeatureBullet(icon: Icons.track_changes_rounded, text: 'Track your learning progress'),
                  ],
                ),
              ),
            ),
            // Right card
            Expanded(
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: SingleChildScrollView(child: _buildFormContent()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Welcome back! Enter your credentials.',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 13,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 28),
          // Email field
          CustomTextField(
            hint: 'Email',
            controller: _emailController,
            validator: FormValidator.instance.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Password field
          CustomTextField(
            hint: 'Password',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey500,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          // Hint for demo
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Email: test@gmail.com\nPassword: Test@123',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 12,
                          color: AppColors.grey700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureBullet({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
