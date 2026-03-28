// test/widget/task_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planora/domain/models/task.dart';
import 'package:planora/features/tasks/widgets/task_card.dart';

void main() {
  final Task task = Task(
    id: 'task-1',
    title: 'Write report',
    dueDate: DateTime(2026, 3, 30, 10),
    priority: TaskPriority.high,
    updatedAt: DateTime.now(),
  );

  Widget buildWidget({VoidCallback? onToggle}) {
    return MaterialApp(
      home: Scaffold(
        body: TaskCard(task: task, onToggle: onToggle),
      ),
    );
  }

  testWidgets('displays title due date and priority badge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Write report'), findsOneWidget);
    expect(find.textContaining('Monday, 30 March'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
  });

  testWidgets('checkbox tap calls tasks provider toggle callback', (
    WidgetTester tester,
  ) async {
    var toggled = false;

    await tester.pumpWidget(buildWidget(onToggle: () => toggled = true));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(toggled, isTrue);
  });

  testWidgets('swipe wrapper can trigger delete pathway', (
    WidgetTester tester,
  ) async {
    var dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Dismissible(
            key: const ValueKey<String>('task'),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => dismissed = true,
            background: const SizedBox.shrink(),
            secondaryBackground: const ColoredBox(color: Colors.red),
            child: TaskCard(task: task),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(dismissed, isTrue);
  });
}
