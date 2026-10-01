import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../attendance/screens/attendance_screen.dart';
import '../../assignments/screens/assignments_screen.dart';
import '../../notices/screens/notices_screen.dart';
import '../../profile/screens/profile_details_screen.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_attendance_board.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;
  bool _hasNotifications = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getGreeting() {
    final nowNepal = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 45));
    final hour = nowNepal.hour;
    if (hour >= 5 && hour < 12) return 'Good Morning ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon 🌤️';
    if (hour >= 17 && hour < 21) return 'Good Evening 🌇';
    return 'Good Night 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      endDrawer: dashboardAsync.maybeWhen(
        data: (data) => _buildNotificationDrawer(theme, data.notifications),
        orElse: () => null,
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
      body: dashboardAsync.when(
        loading: () => _buildLoadingState(theme),
        error: (err, stack) => Center(child: Text('Dashboard error: $err')),
        data: (data) {
          return IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(theme, data),
              const AttendanceScreen(),
              AssignmentsScreen(assignments: data.assignments, studentId: data.profile?['student_id'] ?? ''),
              _buildProfileTab(data.profile),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHomeTab(ThemeData theme, DashboardData data) {
    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
      displacement: 60,
      color: theme.colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          _buildHeader(theme, data.profile),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchBar(theme),
                const SizedBox(height: 24),
                _buildSectionTitle(theme, 'Quick Actions', notices: data.notices),
                const SizedBox(height: 16),
                DashboardQuickActions(
                  notices: data.notices,
                  onTabSelected: (idx) => setState(() => _currentIndex = idx),
                ),
                const SizedBox(height: 24),
                DashboardAttendanceBoard(
                  attendance: data.attendance,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                const SizedBox(height: 32),
                
                _buildSectionTitle(theme, "Today's Timetable", actionText: 'View All', route: '/timetable', notices: data.notices),
                const SizedBox(height: 16),
                _buildTimetableList(theme, data.timetable),
                const SizedBox(height: 24),
                _buildSectionTitle(theme, "Active Assignments", actionText: '${data.assignments.length} Total', route: '/assignments', notices: data.notices),
                const SizedBox(height: 16),
                _buildAssignmentsList(theme, data.assignments),
                const SizedBox(height: 24),
                _buildSectionTitle(theme, "Recent Results", actionText: 'Details', route: '/results', notices: data.notices),
                const SizedBox(height: 16),
                _buildResultsGrid(theme, data.results),
                const SizedBox(height: 24),
                _buildSectionTitle(theme, "Latest Notices", actionText: 'Archive', route: '/notices', notices: data.notices),
                const SizedBox(height: 16),
                _buildNoticesList(theme, data.notices),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 210,
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.primary.withValues(alpha: 0.1),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: baseColor)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _skeletonBox(100, 20, baseColor),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _skeletonBox(double.infinity, 80, baseColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonBox(double.infinity, 80, baseColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonBox(double.infinity, 80, baseColor)),
                ],
              ),
              const SizedBox(height: 24),
              _skeletonBox(double.infinity, 120, baseColor),
              const SizedBox(height: 24),
              _skeletonBox(150, 20, baseColor),
              const SizedBox(height: 16),
              _skeletonBox(double.infinity, 70, baseColor),
              const SizedBox(height: 12),
              _skeletonBox(double.infinity, 70, baseColor),
              const SizedBox(height: 24),
              _skeletonBox(double.infinity, 150, baseColor),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _skeletonBox(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.05));
  }

  Widget _buildHeader(ThemeData theme, Map<String, dynamic>? profile) {
    final isDark = theme.brightness == Brightness.dark;
    return SliverAppBar(
      expandedHeight: 210,
      floating: false,
      pinned: true,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text('Bridgewater College', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
            ),
            if (_hasNotifications)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ).animate(onPlay: (c) => c.repeat()).fade(duration: 1000.ms, begin: 0.3, end: 1.0),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark 
                ? [const Color(0xFF2C2C2C), const Color(0xFF1A1A1A)] 
                : [theme.colorScheme.primary, theme.colorScheme.primary.withRed(150)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Positioned(
                left: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withValues(alpha: 0.03),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile?['full_name'] ?? 'Student',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.school_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '${profile?['department'] ?? 'Department'} • ID: ${profile?['student_id'] ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _currentIndex = 3),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white24,
                          backgroundImage: (profile?['avatar_url'] != null && (profile!['avatar_url'] as String).isNotEmpty)
                              ? NetworkImage(profile['avatar_url'] as String)
                              : null,
                          child: (profile?['avatar_url'] == null || (profile!['avatar_url'] as String).isEmpty)
                              ? Text(
                                  (profile?['full_name'] ?? 'S').substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, {String? actionText, String? route, List<Map<String, dynamic>>? notices}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        if (actionText != null)
          TextButton(
            onPressed: () {
              if (route == '/attendance') {
                setState(() => _currentIndex = 1);
              } else if (route == '/assignments') {
                setState(() => _currentIndex = 2);
              } else if (route == '/notices' && notices != null) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NoticesScreen(notices: notices)));
              } else if (route != null) {
                Navigator.pushNamed(context, route);
              }
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
            child: Text(
              actionText,
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
      ],
    );
  }

  Widget _buildAssignmentsList(ThemeData theme, List<Map<String, dynamic>> assignments) {
    if (assignments.isEmpty) {
      return _buildEmptyState('There\'s no assignment for u');
    }

    final latestAssignments = assignments.take(3).toList();

    return Column(
      children: latestAssignments.map((a) {
        final dueDate = DateTime.parse(a['due_date'].toString());
        final formatter = dueDate.day == DateTime.now().day && dueDate.month == DateTime.now().month && dueDate.year == DateTime.now().year ? 'Today' : '${dueDate.day}/${dueDate.month}';
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _currentIndex = 2),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      a['subject']?.toString().substring(0, a['subject'].toString().length > 2 ? 3 : a['subject'].toString().length).toUpperCase() ?? 'HW',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['title'] ?? 'Task', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          'Due: $formatter',
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResultsGrid(ThemeData theme, List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return _buildEmptyState('No results published yet');
    }

    final latestGpaNum = results.firstWhere((r) => r['gpa'] != null, orElse: () => {'gpa': null})['gpa'];
    final gpa = latestGpaNum != null ? (latestGpaNum as num).toStringAsFixed(2) : 'N/A';

    final latestResults = results.take(3).toList();

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/results'),
      borderRadius: BorderRadius.circular(20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Latest GPA', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(gpa, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: latestResults.map((r) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(r['subject_name']?.toString() ?? r['subject']?.toString() ?? r['exam_title']?.toString() ?? 'Sub', textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(r['grade']?.toString() ?? '-', style: TextStyle(fontSize: 18, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticesList(ThemeData theme, List<Map<String, dynamic>> notices) {
    if (notices.isEmpty) {
      return _buildEmptyState('No new notices');
    }

    final recentNotices = notices.take(3).toList();

    return Column(
      children: recentNotices.map((n) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign_outlined, color: Colors.blueAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(n['title']?.toString() ?? 'Notice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(n['content']?.toString() ?? n['desc']?.toString() ?? '', style: TextStyle(color: theme.hintColor, fontSize: 12, height: 1.4)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, color: Colors.grey, size: 40),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.assignment_ind_outlined), selectedIcon: Icon(Icons.assignment_ind_rounded), label: 'Attendance'),
          NavigationDestination(
              icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment_rounded), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProfileTab(Map<String, dynamic>? profile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: theme.colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      backgroundImage: (profile?['avatar_url'] != null && (profile!['avatar_url'] as String).isNotEmpty)
                          ? NetworkImage(profile['avatar_url'] as String)
                          : null,
                      child: (profile?['avatar_url'] == null || (profile!['avatar_url'] as String).isEmpty)
                          ? Text(
                              (profile?['full_name'] ?? 'S').substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(profile?['full_name'] ?? 'User Profile', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${profile?['department'] ?? 'BWIC Student'} • Year ${profile?['admission_year'] ?? '1'}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   _buildProfileItem(Icons.person_outline, 'Personal Information', '${profile?['full_name'] ?? 'Loading...'}, ${profile?['email'] ?? 'Loading...'}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreens.personalInfo()))),
                   _buildProfileItem(Icons.security_outlined, 'Privacy & Security', 'Change password, Two-factor auth', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreens.security()))),
                   _buildProfileItem(Icons.settings_outlined, 'App Settings', 'Theme, Notifications, Language', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreens.settings(context)))),
                   _buildProfileItem(Icons.help_outline_rounded, 'Help & Support', 'FAQ, Contact Support', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreens.help()))),
                   const SizedBox(height: 20),
                   ListTile(
                     leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                     title: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                     onTap: () async {
                       final prefs = await SharedPreferences.getInstance();
                       await prefs.remove('student_id');
                       if (context.mounted) {
                         Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                       }
                     },
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(color: theme.hintColor, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses, results...',
          hintStyle: TextStyle(color: theme.hintColor, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNotificationDrawer(ThemeData theme, List<Map<String, dynamic>> notifications) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(24))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 20),
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (_hasNotifications)
                   TextButton(
                    onPressed: () {
                      setState(() => _hasNotifications = false);
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                else
                  const Icon(Icons.done_all_rounded, color: Colors.green, size: 20),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
              ? const Center(child: Text('No unread notifications.', style: TextStyle(color: Colors.grey, fontSize: 13)))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: notifications.map((n) {
                    final title = n['title']?.toString() ?? 'Notification';
                    final content = n['content']?.toString() ?? n['desc']?.toString() ?? '';
                    
                    String timeStr = 'Just now';
                    if (n['created_at'] != null) {
                      final date = DateTime.parse(n['created_at'].toString());
                      final diff = DateTime.now().difference(date);
                      if (diff.inDays > 0) {
                        timeStr = '${diff.inDays}d ago';
                      } else if (diff.inHours > 0) timeStr = '${diff.inHours}h ago';
                      else if (diff.inMinutes > 0) timeStr = '${diff.inMinutes}m ago';
                    }

                    return _buildNotificationItem(
                      theme, 
                      Icons.notifications_active_outlined, 
                      title, 
                      content, 
                      timeStr, 
                      theme.colorScheme.primary
                    );
                  }).toList(),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
               width: double.infinity,
               child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Close Drawer')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(ThemeData theme, IconData icon, String title, String desc, String time, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      onTap: () => _showNotificationDetail(theme, title, desc, icon, color),
    );
  }

  void _showNotificationDetail(ThemeData theme, String title, String desc, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF222222) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 30, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 30)),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(desc, textAlign: TextAlign.center, style: TextStyle(color: theme.hintColor, fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Dismiss', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableList(ThemeData theme, List<Map<String, dynamic>> timetable) {
    if (timetable.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.event_busy_rounded, color: theme.hintColor, size: 32),
            const SizedBox(height: 12),
            const Text(
              'Seems to be a holiday!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enjoy your free time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timetable.length > 3 ? 3 : timetable.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final c = timetable[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(context, '/timetable'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (c['time_start'] ?? '00:00').toString().split(' ')[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['subject_name'] ?? 'Class', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('${c['teacher_name'] ?? 'Faculty'} • ${c['room_number'] ?? 'Auditorium'}', style: TextStyle(color: theme.hintColor, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
