import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/service_providers.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .or('email.eq.$identifier,student_id.eq.$identifier')
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('student_id', response['student_id']);

        // Trigger background sync
        final academic = _ref.read(academicServiceProvider);
        academic.syncAllData(
          studentId: response['student_id'],
          department: response['department'],
          year: (response['admission_year'] as num?)?.toInt(),
          roomNo: response['room_no']?.toString(),
        );

        state = state.copyWith(isLoading: false, isAuthenticated: true);
        return true;
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Invalid ID/Email or Password');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Something went wrong. Please check your connection.');
      return false;
    }
  }

  Future<bool> signup({
    required String fullName,
    required String studentId,
    required String email,
    required String department,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Supabase.instance.client.from('profiles').insert({
        'student_id': studentId,
        'email': email,
        'password': password,
        'full_name': fullName,
        'department': department.isEmpty ? 'General' : department,
      });

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Signup failed. Student ID or Email might already exist.');
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
