import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? const String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://cvcqnwoaxnagekvcqowk.supabase.co',
  );

  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? const String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN2Y3Fud29heG5hZ2VrdmNxb3drIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMDI0MDQsImV4cCI6MjA5MDc3ODQwNH0.b2lJdCrnX106coqSN2Fx0v6H4-39BvFDzdC3DxcWHBw',
  );

  static String get mistralApiUrl => dotenv.env['MISTRAL_API_URL'] ?? const String.fromEnvironment(
    'MISTRAL_API_URL',
    defaultValue: 'https://api.mistral.ai/v1/chat/completions',
  );

  static String get mistralApiKey => dotenv.env['MISTRAL_API_KEY'] ?? const String.fromEnvironment(
    'MISTRAL_API_KEY',
    defaultValue: '',
  );

  static String get collegeWebsite => dotenv.env['COLLEGE_WEBSITE'] ?? 'https://bridgewater.edu.np';
}
