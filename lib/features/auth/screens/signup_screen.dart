import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bridgewatercollege/core/widgets/custom_text_field.dart';
import 'package:bridgewatercollege/core/widgets/primary_button.dart';
import 'package:bridgewatercollege/core/widgets/auth_header.dart';
import 'package:bridgewatercollege/core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).signup(
        fullName: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        email: _emailController.text.trim(),
        department: _departmentController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/');
        } else {
          final errorMsg = ref.read(authProvider).errorMessage ?? 'Signup failed.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.redAccent,
            ),
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(
                    title: 'Create Account',
                    subtitle: 'Sign up to get started with Bridgewater',
                  ),
                  const SizedBox(height: 24),
                  
                  _buildTextFieldLabel('Full Name'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    label: '',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Full name is required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldLabel('College Student ID'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _studentIdController,
                    label: '',
                    prefixIcon: Icons.badge_outlined,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Student ID is required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldLabel('Email Address'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _emailController,
                    label: '',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldLabel('Department / Faculty'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _departmentController,
                    label: '',
                    prefixIcon: Icons.school_outlined,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Department is required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldLabel('Password'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _passwordController,
                    label: '',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    onSuffixIconPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Password is required';
                      if (v.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: '',
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock_clock_outlined,
                    onSuffixIconPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    validator: (v) {
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Sign Up',
                    isLoading: authState.isLoading,
                    onPressed: _handleSignup,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/'),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
