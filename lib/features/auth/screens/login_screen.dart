import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bridgewatercollege/core/widgets/custom_text_field.dart';
import 'package:bridgewatercollege/core/widgets/primary_button.dart';
import 'package:bridgewatercollege/core/widgets/auth_header.dart';
import 'package:bridgewatercollege/core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final identifier = _idController.text.trim();
      final password = _passwordController.text.trim();

      final success = await ref.read(authProvider.notifier).login(identifier, password);

      if (mounted) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final errorMsg = ref.read(authProvider).errorMessage ?? 'Invalid ID/Email or Password';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light 
          ? const Color(0xFFF8F9FA) 
          : AppTheme.darkBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final isShort = constraints.maxHeight < 700;
          final screenWidth = constraints.maxWidth;
          final formWidth = isMobile ? screenWidth * 0.9 : (screenWidth > 1200 ? 500.0 : screenWidth * 0.5);
          
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12.0 : 40.0, 
                vertical: isShort ? 20.0 : 40.0
              ),
              child: SizedBox(
                width: formWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 0 : 24, 
                    vertical: isShort ? 10 : 40
                  ),
                  child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthHeader(
                        title: 'Sign In',
                        subtitle: 'Enter your credentials to continue',
                      ),
                      const SizedBox(height: 32),
                      _buildTextFieldLabel('College ID or Email'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _idController,
                        label: '',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your ID or Email';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 10, end: 0),
                      const SizedBox(height: 20),
                      _buildTextFieldLabel('Password'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        label: '',
                        isPassword: true,
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        onSuffixIconPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 900.ms).slideY(begin: 10, end: 0),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: AppTheme.crimson,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                              ),
                              const Text('Remember me', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please contact college administration to reset your password.')),
                              );
                            },
                            child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppTheme.crimson, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1000.ms),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'Sign In',
                        isLoading: authState.isLoading,
                        onPressed: _handleLogin,
                      ).animate().fadeIn(delay: 1100.ms).slideY(begin: 10, end: 0),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1200.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
