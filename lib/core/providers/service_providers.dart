import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/academic_service.dart';
import '../services/profile_service.dart';

final academicServiceProvider = Provider<AcademicService>((ref) {
  return AcademicService();
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});
