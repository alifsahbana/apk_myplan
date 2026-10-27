import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:apk_myplant/main.dart';
import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/tasks/data/task_repository.dart';
import 'package:apk_myplant/features/tasks/data/task_list_repository.dart';
import 'package:apk_myplant/features/gamification/domain/gamification_service.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('MyPlan smoke test', (WidgetTester tester) async {
    // Initialize in-memory test database, repositories, and services
    final database = AppDatabase(NativeDatabase.memory());
    final taskRepo = TaskRepository(database);
    final listRepo = TaskListRepository(database);
    final gamificationService = GamificationService(database);
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyPlanApp(
      database: database,
      taskRepository: taskRepo,
      listRepository: listRepo,
      gamificationService: gamificationService,
    ));

    await tester.pumpAndSettle();

    // Verify that the app builds.
    expect(find.byType(MyPlanApp), findsOneWidget);

    await database.close();
  });
}
