import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../widgets/security_info_banner.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('student_id');
      if (studentId == null) throw Exception('Session expired.');

      final result = await Supabase.instance.client
          .from('profiles')
          .select('student_id')
          .eq('student_id', studentId)
          .eq('password', _currentPasswordController.text.trim())
          .maybeSingle();

      if (result == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Current password is incorrect.'), backgroundColor: Colors.redAccent),
          );
        }
        return;
      }

      await Supabase.instance.client
          .from('profiles')
          .update({'password': _newPasswordController.text.trim()})
          .eq('student_id', studentId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password. Please check your connection.'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SecurityInfoBanner(
                text: 'Update your password periodically to keep your account secure.',
              ),
              const SizedBox(height: 32),
              const Text('CURRENT PASSWORD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _currentPasswordController,
                label: 'Enter current password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                validator: (v) => v!.isEmpty ? 'Enter current password' : null,
              ),
              const SizedBox(height: 24),
              const Text('NEW PASSWORD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _newPasswordController,
                label: 'Enter new password',
                prefixIcon: Icons.password_rounded,
                isPassword: true,
                validator: (v) => v!.length < 6 ? 'Min. 6 characters required' : null,
              ),
              const SizedBox(height: 24),
              const Text('CONFIRM NEW PASSWORD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Re-enter new password',
                prefixIcon: Icons.check_circle_outline_rounded,
                isPassword: true,
                validator: (v) => v != _newPasswordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'UPDATE PASSWORD',
                isLoading: _isLoading,
                onPressed: _handleChangePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
