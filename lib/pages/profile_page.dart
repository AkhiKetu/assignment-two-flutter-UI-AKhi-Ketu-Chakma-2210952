
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // STUDENT INFORMATION
  static const String studentName = 'Akhi Ketu Chakma';
  static const String studentId = '2210952';
  static const String initials = 'AKC';

 
  static const String email = '2210952@iub.edu.bd';
  static const String phone = '01894852404';

  static const String department ='Computer Science';
  static const String semester = 'Autumn 2026';

  // PREFERENCE STATES
  bool notifications = true;
  bool darkMode = false;
  TimeOfDay reminderTime = const TimeOfDay(
    hour: 20,
    minute: 0,
  );

  // SELECT STUDY REMINDER TIME
  Future<void> selectReminderTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (selected != null && mounted) {
      setState(() {
        reminderTime = selected;
      });
    }
  }

  // LOGOUT BUTTON DEMO
  void showLogoutMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text(
          'This is a UI demo. No login system is connected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bgColor = darkMode
        ? const Color(0xFF0F172A)
        : const Color(0xFFF7F9FC);

    final cardColor = darkMode
        ? const Color(0xFF1E293B)
        : Colors.white;

    final textColor = darkMode
        ? Colors.white
        : const Color(0xFF172033);

    final subColor = darkMode
        ? Colors.white70
        : const Color(0xFF64748B);

    return ColoredBox(
      color: bgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. PROFILE HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Manage your preferences below',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: cardColor,
                      foregroundColor: textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. STUDENT AVATAR AND NAME
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFF4285F4),
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      studentName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      studentId,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. PERSONAL DETAILS
              sectionTitle('Personal details', textColor),

              const SizedBox(height: 10),

              Container(
                decoration: cardDecoration(cardColor),
                child: Column(
                  children: [
                    infoRow(
                      Icons.badge_outlined,
                      'Student ID',
                      studentId,
                      textColor,
                    ),
                    divider(),

                    infoRow(
                      Icons.email_outlined,
                      'Email',
                      email,
                      textColor,
                    ),
                    divider(),

                    infoRow(
                      Icons.phone_outlined,
                      'Phone',
                      phone,
                      textColor,
                    ),
                    divider(),

                    infoRow(
                      Icons.menu_book_outlined,
                      'Department',
                      department,
                      textColor,
                    ),
                    divider(),

                    infoRow(
                      Icons.calendar_today_outlined,
                      'Semester',
                      semester,
                      textColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 4. PREFERENCES
              sectionTitle('Preferences', textColor),

              const SizedBox(height: 10),

              Container(
                decoration: cardDecoration(cardColor),
                child: Column(
                  children: [

                    // NOTIFICATIONS
                    preferenceRow(
                      Icons.notifications_outlined,
                      'Notifications',
                      textColor,
                      Switch(
                        value: notifications,
                        activeColor: const Color(0xFF2563EB),
                        onChanged: (value) {
                          setState(() {
                            notifications = value;
                          });
                        },
                      ),
                    ),

                    divider(),

                    // STUDY REMINDER
                    InkWell(
                      onTap: selectReminderTime,
                      child: preferenceRow(
                        Icons.access_time_outlined,
                        'Study reminder',
                        textColor,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              reminderTime.format(context),
                              style: TextStyle(
                                fontSize: 12,
                                color: subColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.chevron_right,
                              color: subColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    divider(),

                    // DARK MODE
                    preferenceRow(
                      Icons.dark_mode_outlined,
                      'Dark mode',
                      textColor,
                      Switch(
                        value: darkMode,
                        activeColor: const Color(0xFF2563EB),
                        onChanged: (value) {
                          setState(() {
                            darkMode = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 5. LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: showLogoutMessage,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: cardColor,
                    side: const BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                    padding: const EdgeInsets.all(13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Color(0xFFE11D48),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SECTION TITLE
  Widget sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  // WHITE CARD DESIGN
  BoxDecoration cardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
      ),
    );
  }

  // DIVIDER
  Widget divider() {
    return const Divider(
      height: 1,
      indent: 45,
      endIndent: 12,
      color: Color(0xFFE2E8F0),
    );
  }

  // PERSONAL DETAILS ROW
  Widget infoRow(
    IconData icon,
    String label,
    String value,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2563EB),
            size: 19,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PREFERENCES ROW
  Widget preferenceRow(
    IconData icon,
    String title,
    Color textColor,
    Widget trailing,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
