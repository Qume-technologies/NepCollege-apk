import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/service_providers.dart';

class ResultsData {
  final List<Map<String, dynamic>> results;
  final int? rank;

  const ResultsData({required this.results, this.rank});
}

class ResultsNotifier extends StateNotifier<AsyncValue<ResultsData>> {
  final Ref _ref;

  ResultsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadResults();
  }

  Future<void> loadResults() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('student_id') ?? '';

      final data = await academicService.getResults();

      int? rank;
      if (data.isNotEmpty && data.first['exam_id'] != null) {
        rank = await academicService.getExamRank(data.first['exam_id'].toString(), studentId);
      }

      state = AsyncValue.data(ResultsData(results: data, rank: rank));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadResults();
  }
}

final resultsProvider = StateNotifierProvider<ResultsNotifier, AsyncValue<ResultsData>>((ref) {
  return ResultsNotifier(ref);
});
