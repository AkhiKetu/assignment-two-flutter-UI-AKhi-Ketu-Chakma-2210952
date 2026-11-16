
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late DateTime selectedWeek;

  final List<Map<String, dynamic>> courses = [
    {
      'code': '464',
      'name': 'CSE 464 · Mobile Dev',
      'next': 'Next: Lab 6, today',
      'progress': 0.72,
      'color': const Color(0xFF2563EB),
      'light': const Color(0xFFEAF2FF),
    },
    {
      'code': '303',
      'name': 'CSE 303 · Databases',
      'next': 'Next: ER diagram, Sat',
      'progress': 0.58,
      'color': const Color(0xFFF59E0B),
      'light': const Color(0xFFFEF3C7),
    },
    {
      'code': '212',
      'name': 'MAT 212 · Linear Algebra',
      'next': 'Next: Problem set 4, Mon',
      'progress': 0.84,
      'color': const Color(0xFF10B981),
      'light': const Color(0xFFD1FAE5),
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedWeek = startOfWeek(DateTime.now());
  }

  // Get Monday of a particular week
  DateTime startOfWeek(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return day.subtract(
      Duration(days: day.weekday - 1),
    );
  }

  // Create the week label
  String weekLabel() {
    final end = selectedWeek.add(
      const Duration(days: 6),
    );

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];

    if (selectedWeek.month == end.month) {
      return '${selectedWeek.day} to '
          '${end.day} ${months[end.month - 1]}';
    }

    return '${selectedWeek.day} '
        '${months[selectedWeek.month - 1]} to '
        '${end.day} ${months[end.month - 1]}';
  }

  // Check if the selected week is the current week
  bool get isCurrentWeek {
    final current = startOfWeek(DateTime.now());

    return selectedWeek.year == current.year &&
        selectedWeek.month == current.month &&
        selectedWeek.day == current.day;
  }

  // Change between weeks
  void changeWeek(int direction) {
    setState(() {
      selectedWeek = selectedWeek.add(
        Duration(days: direction * 7),
      );
    });
  }

  // Open calendar
  Future<void> openCalendar() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedWeek,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        selectedWeek = startOfWeek(picked);
      });
    }
  }

  // Show course details
  void showCourseDetails(Map<String, dynamic> course) {
    final percent =
        ((course['progress'] as double) * 100).round();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(course['name'] as String),
        content: Text(
          'Course progress: $percent%\n'
          '${course['next']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Manage courses button
  void manageCourses() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ...courses.map((course) {
                final percent =
                    ((course['progress'] as double) * 100)
                        .round();

                return ListTile(
                  title: Text(course['name'] as String),
                  subtitle: Text(
                    course['next'] as String,
                  ),
                  trailing: Text('$percent%'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = isCurrentWeek;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. HEADER
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
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

            const SizedBox(height: 16),

            // 2. WEEK NAVIGATION
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => changeWeek(-1),
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 22,
                    ),
                  ),
                  Text(
                    '${current ? "This week" : "Week"} · '
                    '${weekLabel()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  IconButton(
                    onPressed: () => changeWeek(1),
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 3. STATISTICS CARDS
            Row(
              children: [
                Expanded(
                  child: statCard(
                    Icons.access_time,
                    current ? '9h 21m' : '0h 0m',
                    'Studied',
                    const Color(0xFF2563EB),
                    const Color(0xFFEAF2FF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statCard(
                    Icons.check_box_outlined,
                    current ? '14' : '0',
                    'Tasks done',
                    const Color(0xFF059669),
                    const Color(0xFFD1FAE5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statCard(
                    Icons.local_fire_department_outlined,
                    current ? '6 days' : '0 days',
                    'Streak',
                    const Color(0xFFD97706),
                    const Color(0xFFFEF3C7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 4. WEEKLY PROGRESS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'This week',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),
                      Text(
                        current ? '78%' : '0%',
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    current
                        ? '9h 21m of 12h goal'
                        : '0h of 12h goal',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 13),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: current ? 0.78 : 0.0,
                      minHeight: 7,
                      color: const Color(0xFF2563EB),
                      backgroundColor:
                          const Color(0xFFE2E8F0),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (current)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '↗ +18% vs last week',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'No recorded data for this week',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. COURSES HEADER
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
                TextButton(
                  onPressed: manageCourses,
                  child: const Text('Manage'),
                ),
              ],
            ),

            const SizedBox(height: 7),

            // 6. COURSE PROGRESS CARDS
            ...courses.map((course) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: courseCard(course),
              );
            }),
          ],
        ),
      ),
    );
  }

  // REUSABLE STATISTICS CARD
  Widget statCard(
    IconData icon,
    String value,
    String label,
    Color color,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // REUSABLE COURSE CARD
  Widget courseCard(Map<String, dynamic> course) {
    final color = course['color'] as Color;
    final light = course['light'] as Color;
    final progress = course['progress'] as double;
    final percent = (progress * 100).round();

    return Container(
      decoration: cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => showCourseDetails(course),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              // COURSE CODE
              Container(
                width: 38,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: light,
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Text(
                  course['code'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ),

              const SizedBox(width: 11),

              // COURSE DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF172033),
                            ),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      course['next'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        color: color,
                        backgroundColor:
                            const Color(0xFFE2E8F0),
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

  // COMMON CARD STYLE
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
      ),
    );
  }
}
