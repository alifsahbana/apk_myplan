import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/add_task_modal.dart';
import '../models/models.dart';

/// MyPlan App Router configuration
/// 
/// Main routes:
/// - / (home) - Beranda
/// - /calendar - Kalender
/// - /tasks - Tugas (uses home with different tab)
/// - /profile - Profil
/// - /task/:id - Task Detail
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Shell route for bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: HomeScreen(
                onAddTask: () => _showAddTaskModal(context),
                onTaskTapped: (task) => _navigateToTaskDetail(context, task),
              ),
            ),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      
      // Task detail route (outside shell, has its own scaffold)
      GoRoute(
        path: '/task/:id',
        name: 'task-detail',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          // Will load task from database
          return TaskDetailScreen(
            task: TaskModel(
              taskId: taskId,
              userId: 'user-default',
              title: 'Loading...',
              energyLevel: EnergyLevel.medium,
              date: DateTime.now(),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );

  static void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskModal(initialUserId: 'user-default'),
    );
  }

  static void _navigateToTaskDetail(BuildContext context, TaskModel task) {
    context.push('/task/${task.taskId}');
  }
}

/// Main shell with bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;
  
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        return 0;
      case '/calendar':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0;
    }
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFD9E8F0), width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, currentIndex, Icons.today_outlined, Icons.today, 'Beranda'),
                _navItem(1, currentIndex, Icons.calendar_month_outlined, Icons.calendar_month, 'Kalender'),
                _navItem(2, currentIndex, Icons.person_outline, Icons.person, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, int currentIndex, IconData icon, IconData activeIcon, String label) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF087FA8).withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? const Color(0xFF087FA8) : const Color(0xFF72899A),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? const Color(0xFF087FA8) : const Color(0xFF72899A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
