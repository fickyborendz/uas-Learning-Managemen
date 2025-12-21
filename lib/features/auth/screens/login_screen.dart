import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/forgot_password_link.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../firebase_options.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // App Logo
              const AppLogo(size: 80),
              
              const SizedBox(height: 32),
              
              // Welcome Text
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Sign in to continue learning',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Login Form
              const LoginForm(),
              
              const SizedBox(height: 24),
              
              // Forgot Password Link
              const ForgotPasswordLink(),
              
              const SizedBox(height: 32),
              
              // Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Social Login Buttons
              const SocialLoginButtons(),
              
              const SizedBox(height: 32),
              
              // Error Message
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        authProvider.errorMessage,
                        style: TextStyle(color: Colors.red.shade700),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 16),
              
              // Firebase Configuration Info (for debugging)
              _buildConfigInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigInfoCard() {
    final firebaseConfig = DefaultFirebaseOptions.currentPlatform;
    final isConfigured = !firebaseConfig.apiKey.contains('YOUR_');
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isConfigured ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isConfigured ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isConfigured ? Icons.check_circle : Icons.warning,
                color: isConfigured ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isConfigured 
                      ? 'Firebase Configuration: OK'
                      : 'Firebase Configuration: BELUM DIKONFIGURASI',
                  style: TextStyle(
                    color: isConfigured ? Colors.green.shade700 : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (!isConfigured) ...[
            const SizedBox(height: 8),
            const Text(
              'Silakan ikuti panduan di FIREBASE_SETUP_GUIDE.md untuk mengkonfigurasi Firebase dengan benar.',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}