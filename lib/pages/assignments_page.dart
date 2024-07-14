import 'package:flutter/material.dart';
import 'package:studysensei/services/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/add_assignment.dart';

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _allAssignments = [];
  List<dynamic> _selectedDayAssignments = [];
  int _currentIndex = 0;

  final Map<String, Color> subjectColors = {
    'Maths': SubjectColors.red,
    'Science': SubjectColors.green,
    '2nd Language': SubjectColors.orange,
    'English': SubjectColors.pink,
    'Social Science': SubjectColors.purple,
    'AI': SubjectColors.teal,
  };

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay; // Initialize _selectedDay
    _fetchAssignments(); // Fetch assignments when the page initializes
  }

  Future<void> _fetchAssignments() async {
    final response = await supabase.from('assignments').select('*').execute();

    if (response.error != null) {
      throw Exception('Failed to fetch assignments');
    }

    final List assignments = response.data;
    _events = {}; // Clear existing events
    _allAssignments = assignments; // Store all assignments

    assignments.forEach((assignment) {
      DateTime deadline = DateTime.parse(assignment['deadline']);
      if (_events.containsKey(deadline)) {
        _events[deadline]!.add(assignment);
      } else {
        _events[deadline] = [assignment];
      }
    });

    _filterAssignmentsForSelectedDay(); // Filter assignments for the selected day

    setState(() {}); // Update UI after fetching assignments
  }

  void _filterAssignmentsForSelectedDay() {
    _selectedDayAssignments = _allAssignments
        .where((assignment) =>
        isSameDay(DateTime.parse(assignment['deadline']), _selectedDay))
        .toList();
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.Apricot,
        elevation: 40.0,
        title: const Padding(
          padding: EdgeInsets.only(left: 60, bottom: 10),
          child: Text('StudySensei', style: TextStyle(fontFamily: 'DancingScript', fontSize: 50, fontWeight: FontWeight.bold),),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: AppColors.Apricot,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAssignmentPage()),
          );
          if (result == true) {
            _fetchAssignments(); // Refresh assignments after adding new one
          }
        },
        child: const Icon(Icons.add),
      )
          : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildCalendarView();
      case 1:
        return _buildListView();
      default:
        return Container();
    }
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false, // Remove format button
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.Sky,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.Cobalt,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) => _getEventsForDay(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // Update focusedDay
              _filterAssignmentsForSelectedDay(); // Filter assignments for the selected day
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedDayAssignments.length,
            itemBuilder: (context, index) {
              final assignment = _selectedDayAssignments[index];
              return _buildAssignmentCard(assignment);
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildListView() {
  //   return _allAssignments.isEmpty
  //       ? const Center(
  //     child: Text(
  //       'Hooray! Your free so go play something!',
  //       style: TextStyle(fontSize: 18.0),
  //     ),
  //   )
  //       : ListView.builder(
  //     itemCount: _allAssignments.length,
  //     itemBuilder: (context, index) {
  //       final assignment = _allAssignments[index];
  //       return _buildAssignmentCard(assignment);
  //     },
  //   );
  // }
  Widget _buildListView() {
    if (_allAssignments.isEmpty) {
      return const Center(
        child: Text(
          'No assignments available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Assignments:',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, fontFamily: 'SubHeading'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allAssignments.length,
              itemBuilder: (context, index) {
                final assignment = _allAssignments[index];
                return _buildAssignmentCard(assignment);
              },
            ),
          ),
        ],
      );
    }
  }


  Widget _buildAssignmentCard(dynamic assignment) {
    // Parse the deadline string to DateTime
    DateTime deadline = DateTime.parse(assignment['deadline']);

    // Format the deadline to 'dd/MM/yyyy' format
    String formattedDeadline = '${deadline.day.toString().padLeft(2, '0')}/${deadline.month.toString().padLeft(2, '0')}/${deadline.year}';

    return Dismissible(
            key: Key(assignment['id'].toString()), // Unique key for each Dismissible widget
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await _deleteAssignment(assignment['id']);
              _fetchAssignments(); // Refresh assignments after deletion
            },
            child: Card(
              color: subjectColors[assignment['subject']], // Set card color based on subject
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(assignment['name'], style: const TextStyle(fontFamily: 'Headings', fontSize: 25, fontWeight: FontWeight.w900),),
                subtitle: Text('Subject: ${assignment['subject']}\nDeadline: $formattedDeadline', style: TextStyle(fontFamily: 'SubHeading', fontWeight: FontWeight.w200, color: Colors.black),),
              ),
            ),
          );
  }


  Future<void> _deleteAssignment(int id) async {
    final response = await supabase.from('assignments').delete().eq('id', id).execute();

    if (response.error != null) {
      throw Exception('Failed to delete assignment');
    }
  }
}
