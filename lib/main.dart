import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/app_database.dart';
import 'features/tasks/data/task_repository.dart';
import 'features/tasks/data/task_list_repository.dart';
import 'features/tasks/providers/tasks_provider.dart';
import 'features/gamification/domain/gamification_service.dart';
import 'providers/language_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/task_provider.dart';
import 'core/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  // Initialize database
  final database = AppDatabase();
  
  // Initialize repositories & services
  final taskRepo = TaskRepository(database);
  final listRepo = TaskListRepository(database);
  final gamificationService = GamificationService(database);
  
  runApp(MyPlanApp(
    database: database,
    taskRepository: taskRepo,
    listRepository: listRepo,
    gamificationService: gamificationService,
  ));
}

class MyPlanApp extends StatelessWidget {
  final AppDatabase database;
  final TaskRepository taskRepository;
  final TaskListRepository listRepository;
  final GamificationService gamificationService;
  
  const MyPlanApp({
    super.key,
    required this.database,
    required this.taskRepository,
    required this.listRepository,
    required this.gamificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Database provider
        Provider<AppDatabase>.value(value: database),
        
        // Repository & service providers
        Provider<TaskRepository>.value(value: taskRepository),
        Provider<TaskListRepository>.value(value: listRepository),
        Provider<GamificationService>.value(value: gamificationService),
        
        // State providers
        ChangeNotifierProvider(
          create: (_) => TasksProvider(
            taskRepository: taskRepository,
            listRepository: listRepository,
            gamificationService: gamificationService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            database: database,
            gamificationService: gamificationService,
          ),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProv, _) {
          return MaterialApp.router(
            title: 'MyPlan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            locale: Locale(langProv.currentLocale),
          );
        },
      ),
    );
  }
}
