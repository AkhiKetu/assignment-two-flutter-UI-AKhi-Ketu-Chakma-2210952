
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSeeAll;

  const HomePage({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final monday = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final greeting = today.hour < 12
        ? 'Good morning,'
        : today.hour < 17
            ? 'Good afternoon,'
            : 'Good evening,';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. HEADER
            Row(
              children: [
                const CircleAvatar(
                  radius: 21,
                  backgroundColor: Color(0xFF4285F4),
                  child: Text(
                    'AKC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const Text(
                        'Akhi Ketu Chakma',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No new notifications'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 2. WEEKLY CALENDAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = monday.add(
                  Duration(days: index),
                );

                return calendarDay(
                  ['Mon', 'Tue', 'Wed', 'Thu',
                   'Fri', 'Sat', 'Sun'][index],
                  '${date.day}',
                  date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year,
                );
              }),
            ),

            const SizedBox(height: 25),

            // 3. STUDY GOAL CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1E40AF),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TODAY'S STUDY GOAL",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '2h 15m',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'of 3h',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 7,
                      backgroundColor: Color(0xFF6688DE),
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    '3 tasks due today · 6 day streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 4. DUE SOON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due soon',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text('See all'),
                ),
              ],
            ),

            taskCard(
              'Lab 6: Navigation and routing',
              'CSE 464 · Today, 11:59 PM',
              'High',
              const Color(0xFFFF3B65),
            ),

            const SizedBox(height: 10),

            taskCard(
              'ER diagram for library system',
              'CSE 303 · Tomorrow, 5:00 PM',
              'Medium',
              const Color(0xFFFFA500),
            ),

            const SizedBox(height: 26),

            // 5. TODAY'S CLASSES
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's classes",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Timetable',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: classCard(
                    '10:00 AM',
                    'CSE 464',
                    'Room 7012',
                    const Color(0xFFEEF5FF),
                    const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: classCard(
                    '1:30 PM',
                    'MAT 212',
                    'Room 3021',
                    const Color(0xFFECFDF5),
                    const Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // CALENDAR WIDGET
  Widget calendarDay(
    String day,
    String date,
    bool selected,
  ) {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF2563EB)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              color: selected
                  ? Colors.white
                  : Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // TASK CARD WIDGET
  Widget taskCard(
    String title,
    String subtitle,
    String priority,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 35,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              priority,
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

  // CLASS CARD WIDGET
  Widget classCard(
    String time,
    String course,
    String room,
    Color background,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            room,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
