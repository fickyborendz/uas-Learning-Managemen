import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign In Button
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: authProvider.isLoading 
                    ? null 
                    : () async {
                        final success = await authProvider.signInWithGoogle();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Google login successful!')),
                          );
                        }
                      },
                icon: _buildGoogleIcon(),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // You can add more social login options here
        // Like Facebook, Apple, etc.
      ],
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://developers.google.com/identity/images/g-logo.png'
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _handleGoogleSignIn() {
    // This will be called from within the build context
    // so we don't need to handle it here
  }
}