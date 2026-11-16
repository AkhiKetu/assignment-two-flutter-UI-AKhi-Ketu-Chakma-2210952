
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

// Simple model to store task information
class StudyTask {
  String title;
  String course;
  String time;
  String priority;
  bool tomorrow;
  bool completed;

  StudyTask({
    required this.title,
    required this.course,
    required this.time,
    required this.priority,
    this.tomorrow = false,
    this.completed = false,
  });
}

class _TasksPageState extends State<TasksPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String searchText = '';
  DateTime? selectedDate;

  // Sample tasks from the Figma design
  final List<StudyTask> tasks = [
    StudyTask(
      title: 'Lab 6: Navigation and routing',
      course: 'CSE 464',
      time: '11:59 PM',
      priority: 'High',
    ),
    StudyTask(
      title: 'Read chapter 7: Normalization',
      course: 'CSE 303',
      time: '6:00 PM',
      priority: 'Medium',
    ),
    StudyTask(
      title: 'Submit quiz 3 reflection',
      course: 'MAT 212',
      time: '2:00 PM',
      priority: 'Low',
      completed: true,
    ),
    StudyTask(
      title: 'ER diagram for library system',
      course: 'CSE 303',
      time: '5:00 PM',
      priority: 'Medium',
      tomorrow: true,
    ),
    StudyTask(
      title: 'Watch lecture 9',
      course: 'CSE 464',
      time: '8:00 PM',
      priority: 'Low',
      tomorrow: true,
    ),
  ];

  // Returns color based on priority
  Color priorityColor(String priority) {
    if (priority == 'High') {
      return const Color(0xFFEF4444);
    }
    if (priority == 'Medium') {
      return const Color(0xFFD97706);
    }
    return const Color(0xFF059669);
  }

  bool sameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String dateLabel(DateTime date) {
    const days = [
      'MON', 'TUE', 'WED', 'THU',
      'FRI', 'SAT', 'SUN',
    ];

    const months = [
      'JAN', 'FEB', 'MAR', 'APR',
      'MAY', 'JUN', 'JUL', 'AUG',
      'SEP', 'OCT', 'NOV', 'DEC',
    ];

    return '${days[date.weekday - 1]}, '
        '${date.day} ${months[date.month - 1]}';
  }

  // Calendar click interaction
  Future<void> openCalendar() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Add task dialog
  Future<void> addTask() async {
    final formKey = GlobalKey<FormState>();

    String title = '';
    String course = '';
    String time = '6:00 PM';
    String priority = 'Medium';
    String day = 'Today';

    final newTask = await showDialog<StudyTask>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Task title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Enter a task title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value!.trim();
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        course = value?.trim() ?? '';
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: '6:00 PM',
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        time = value?.trim() ?? '';
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: 'Medium',
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['High', 'Medium', 'Low']
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        priority = value ?? 'Medium';
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: 'Today',
                      decoration: const InputDecoration(
                        labelText: 'Due date',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Today', 'Tomorrow']
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        day = value ?? 'Today';
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                formKey.currentState!.save();

                Navigator.pop(
                  dialogContext,
                  StudyTask(
                    title: title,
                    course: course.isEmpty
                        ? 'Personal'
                        : course,
                    time: time.isEmpty
                        ? '6:00 PM'
                        : time,
                    priority: priority,
                    tomorrow: day == 'Tomorrow',
                  ),
                );
              },
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );

    if (!mounted || newTask == null) return;

    setState(() {
      tasks.add(newTask);
      searchText = '';
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final today = DateTime.now();
    final tomorrow = today.add(
      const Duration(days: 1),
    );

    final filtered = tasks.where((task) {
      final query = searchText.toLowerCase();

      return task.title.toLowerCase().contains(query) ||
          task.course.toLowerCase().contains(query);
    }).toList();

    final todayTasks = filtered.where((task) {
      return !task.tomorrow &&
          (selectedDate == null ||
              sameDate(selectedDate!, today));
    }).toList();

    final tomorrowTasks = filtered.where((task) {
      return task.tomorrow &&
          (selectedDate == null ||
              sameDate(selectedDate!, tomorrow));
    }).toList();

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16, 18, 16, 95,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                    IconButton(
                      onPressed: openCalendar,
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 21,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // SEARCH BAR
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks, courses...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // SELECTED DATE FILTER
                if (selectedDate != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Showing ${dateLabel(selectedDate!)}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = null;
                          });
                        },
                        child: const Text('Show all'),
                      ),
                    ],
                  ),

                // TODAY'S TASKS
                if (todayTasks.isNotEmpty)
                  taskSection(
                    'TODAY',
                    dateLabel(today),
                    todayTasks,
                  ),

                if (todayTasks.isNotEmpty &&
                    tomorrowTasks.isNotEmpty)
                  const SizedBox(height: 22),

                // TOMORROW'S TASKS
                if (tomorrowTasks.isNotEmpty)
                  taskSection(
                    'TOMORROW',
                    dateLabel(tomorrow),
                    tomorrowTasks,
                  ),

                if (todayTasks.isEmpty &&
                    tomorrowTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(35),
                    child: Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ADD TASK BUTTON
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'add_task_button',
              onPressed: addTask,
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  // TODAY / TOMORROW SECTION
  Widget taskSection(
    String label,
    String date,
    List<StudyTask> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$label · $date',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            Text(
              '${items.length} TASKS',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        for (final task in items) ...[
          taskCard(task),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // REUSABLE TASK CARD
  Widget taskCard(StudyTask task) {
    final color = priorityColor(task.priority);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          // CHECKBOX
          Checkbox(
            value: task.completed,
            activeColor: const Color(0xFF2563EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              setState(() {
                task.completed = value ?? false;
              });
            },
          ),

          // TASK DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: task.completed
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF172033),
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.course} · ${task.time}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          // PRIORITY BADGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.priority,
              style: TextStyle(
                fontSize: 10,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
