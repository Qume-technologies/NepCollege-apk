import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class DashboardData {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? attendance;
  final List<Map<String, dynamic>> timetable;
  final List<Map<String, dynamic>> assignments;
  final List<Map<String, dynamic>> notices;
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> results;

  const DashboardData({
    this.profile,
    this.attendance,
    this.timetable = const [],
    this.assignments = const [],
    this.notices = const [],
    this.notifications = const [],
    this.results = const [],
  });
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final Ref _ref;

  DashboardNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    state = const AsyncValue.loading();
    try {
      final profileService = _ref.read(profileServiceProvider);
      final academicService = _ref.read(academicServiceProvider);

      final profile = await profileService.getProfile();
      final results = await Future.wait([
        Future.value(profile),
        academicService.getAttendance(),
        academicService.getTimetable(
          department: profile?['department'],
          year: (profile?['admission_year'] as num?)?.toInt(),
          roomNo: profile?['room_no'],
        ),
        academicService.getNotices(
          department: profile?['department'],
          roomNo: profile?['room_no']?.toString(),
        ),
        academicService.getResults(),
        academicService.getAssignments(
          department: profile?['department'],
          year: (profile?['admission_year'] as num?)?.toInt(),
          roomNo: profile?['room_no'],
        ),
        academicService.getNotifications(
          studentId: profile?['student_id']?.toString(),
          department: profile?['department'],
          roomNo: profile?['room_no']?.toString(),
        ),
      ]);

      final attendanceList = results[1] as List<Map<String, dynamic>>;
      int totalPresent = 0;
      int totalDays = 0;
      for (var item in attendanceList) {
        totalPresent += (item['present_days'] as num? ?? 0).toInt();
        totalDays += (item['total_days'] as num? ?? 0).toInt();
      }

      state = AsyncValue.data(DashboardData(
        profile: results[0] as Map<String, dynamic>?,
        attendance: {
          'total_classes': totalDays,
          'present_classes': totalPresent,
        },
        timetable: results[2] as List<Map<String, dynamic>>,
        notices: results[3] as List<Map<String, dynamic>>,
        results: results[4] as List<Map<String, dynamic>>,
        assignments: results[5] as List<Map<String, dynamic>>,
        notifications: results[6] as List<Map<String, dynamic>>,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await fetchAllData();
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  return DashboardNotifier(ref);
});
