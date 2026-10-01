import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicService {
  final _supabase = Supabase.instance.client;

  String _buildCacheKey(String baseName, [String? p1, int? p2, String? p3]) {
    return '${baseName}_${p1 ?? ''}_${p2 ?? ''}_${p3 ?? ''}';
  }

  Future<void> syncAllData({String? studentId, String? department, int? year, String? roomNo}) async {
    try {
      await Future.wait([
        getAttendance(),
        getTimetable(department: department, year: year, roomNo: roomNo),
        getAssignments(department: department, year: year, roomNo: roomNo),
        getNotices(department: department, roomNo: roomNo),
        getNotifications(studentId: studentId, department: department, roomNo: roomNo),
        getFees(),
        getResults(),
        getExams(department: department),
        getLeaveNotes(),
      ]);
    } catch (e) {
      debugPrint('Full Sync Error: $e');
    }
  }

  Future<void> _syncPendingLeaves() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingQueue = prefs.getStringList('pending_leave_notes') ?? [];
    if (pendingQueue.isEmpty) return;

    List<String> failedQueue = [];
    for (String itemStr in pendingQueue) {
      try {
        final item = jsonDecode(itemStr);
        await _supabase.from('leave_notes').insert({
          'student_id': item['student_id'],
          'subject': item['subject'],
          'description': item['description'],
          'start_date': item['start_date'],
          'end_date': item['end_date'],
          'status': item['status'],
        });
      } catch (e) {
        failedQueue.add(itemStr);
      }
    }
    await prefs.setStringList('pending_leave_notes', failedQueue);
  }

  Future<List<Map<String, dynamic>>> getAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');
    if (studentId == null) return [];
    
    final cacheKey = 'cache_attendance_$studentId';

    try {
      final List<dynamic> data = await _supabase.from('attendance').select().eq('student_id', studentId);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Attendance fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTimetable({String? department, int? year, String? roomNo}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _buildCacheKey('cache_timetable', department, year, roomNo);

    try {
      var query = _supabase.from('timetable').select();
      if (department != null) query = query.eq('department', department);
      if (year != null) query = query.eq('admission_year', year);
      if (roomNo != null && roomNo.isNotEmpty) query = query.eq('room_number', roomNo);
      
      final List<dynamic> data = await query.order('day_of_week', ascending: true).order('time_start', ascending: true);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Timetable fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAssignments({String? department, int? year, String? roomNo}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _buildCacheKey('cache_assignments', department, year, roomNo);

    try {
      var query = _supabase.from('assignments').select().gte('due_date', DateTime.now().toIso8601String());
      if (department != null) query = query.eq('department', department);
      if (year != null) query = query.eq('admission_year', year);
      if (roomNo != null && roomNo.isNotEmpty) query = query.eq('room_no', roomNo);
      
      final List<dynamic> data = await query.order('due_date', ascending: true);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Assignments fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNotices({String? department, String? roomNo}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _buildCacheKey('cache_notices', department, null, roomNo);

    try {
      var query = _supabase.from('notices').select();
      if (department != null && department.isNotEmpty) {
        query = query.or('department.is.null, department.eq.$department');
      } else {
        query = query.isFilter('department', null);
      }
      if (roomNo != null && roomNo.isNotEmpty) {
        query = query.or('room_no.is.null, room_no.eq.$roomNo');
      } else {
        query = query.isFilter('room_no', null);
      }
      final List<dynamic> data = await query.order('created_at', ascending: false);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Notices fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications({String? studentId, String? department, String? roomNo}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _buildCacheKey('cache_notifications', studentId, null, roomNo);

    try {
      var query = _supabase.from('notifications').select();
      if (studentId != null && studentId.isNotEmpty) {
        query = query.or('student_id.is.null, student_id.eq.$studentId');
      } else {
        query = query.isFilter('student_id', null);
      }
      if (department != null && department.isNotEmpty) {
        query = query.or('department.is.null, department.eq.$department');
      } else {
        query = query.isFilter('department', null);
      }
      if (roomNo != null && roomNo.isNotEmpty) {
        query = query.or('room_no.is.null, room_no.eq.$roomNo');
      } else {
        query = query.isFilter('room_no', null);
      }
      final List<dynamic> data = await query.order('created_at', ascending: false);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Notifications fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFees() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');
    if (studentId == null) return [];
    
    final cacheKey = 'cache_fees_$studentId';

    try {
      final List<dynamic> data = await _supabase.from('fees').select().eq('student_id', studentId);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Fees fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');
    if (studentId == null) return [];
    
    final cacheKey = 'cache_results_$studentId';

    try {
      final List<dynamic> data = await _supabase.from('results').select().eq('student_id', studentId).order('created_at', ascending: false);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Results fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<int?> getExamRank(String examId, String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_exam_rank_${examId}_$studentId';

    try {
      final List<dynamic> data = await _supabase.from('results').select('student_id, gpa').eq('exam_id', examId).not('gpa', 'is', null).order('gpa', ascending: false);
      int currentRank = 1;
      double? prevGpa;
      int? finalRank;
      
      for (int i = 0; i < data.length; i++) {
        final gpa = (data[i]['gpa'] as num).toDouble();
        if (prevGpa != null && gpa < prevGpa) currentRank++;
        if (data[i]['student_id'] == studentId) {
          finalRank = currentRank;
          break;
        }
        prevGpa = gpa;
      }
      
      if (finalRank != null) await prefs.setInt(cacheKey, finalRank);
      return finalRank;
    } catch (e) {
      debugPrint('Rank fetch error (Offline mode): $e');
      return prefs.getInt(cacheKey);
    }
  }

  Future<List<Map<String, dynamic>>> getExams({String? department}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _buildCacheKey('cache_exams', department);

    try {
      var query = _supabase.from('exams').select();
      if (department != null && department.isNotEmpty) {
        query = query.eq('department', department);
      }
      final List<dynamic> data = await query.order('created_at', ascending: false);
      final result = List<Map<String, dynamic>>.from(data);
      await prefs.setString(cacheKey, jsonEncode(result));
      return result;
    } catch (e) {
      debugPrint('Exams fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) return List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');
    if (studentId == null) return [];
    
    final cacheKey = 'cache_leavenotes_$studentId';
    List<Map<String, dynamic>> resultList = [];

    try {
      await _syncPendingLeaves();

      final List<dynamic> data = await _supabase.from('leave_notes').select().eq('student_id', studentId).order('created_at', ascending: false);
      resultList = List<Map<String, dynamic>>.from(data);
      
      await prefs.setString(cacheKey, jsonEncode(resultList));
    } catch (e) {
      debugPrint('Leave notes fetch error (Offline mode): $e');
      final cachedStr = prefs.getString(cacheKey);
      if (cachedStr != null) {
        resultList = List<Map<String, dynamic>>.from(jsonDecode(cachedStr));
      }
    }

    final pendingQueue = prefs.getStringList('pending_leave_notes') ?? [];
    if (pendingQueue.isNotEmpty) {
      final pendingLeaves = pendingQueue.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
      return [...pendingLeaves, ...resultList];
    }

    return resultList;
  }

  Future<bool> submitLeaveNote(String subject, String description, String startDate, String endDate) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');
    if (studentId == null) return false;

    final noteData = {
      'student_id': studentId,
      'subject': subject,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': 'Pending',
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await _supabase.from('leave_notes').insert({
        'student_id': studentId,
        'subject': subject,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
        'status': 'Pending',
      });
      return true;
    } catch (e) {
      debugPrint('Leave note network failed, adding to offline queue: $e');
      List<String> pendingQueue = prefs.getStringList('pending_leave_notes') ?? [];
      pendingQueue.add(jsonEncode(noteData));
      await prefs.setStringList('pending_leave_notes', pendingQueue);
      return true;
    }
  }
}
