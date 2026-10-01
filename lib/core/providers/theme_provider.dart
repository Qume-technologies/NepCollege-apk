import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_manager.dart';

final themeManagerProvider = ChangeNotifierProvider<ThemeManager>((ref) {
  final manager = ThemeManager();
  manager.init();
  return manager;
});
