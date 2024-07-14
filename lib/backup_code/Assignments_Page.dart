// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../services/add_assignment.dart';
//
// class AssignmentPage extends StatefulWidget {
//   @override
//   _AssignmentPageState createState() => _AssignmentPageState();
// }
//
// class _AssignmentPageState extends State<AssignmentPage> {
//   final SupabaseClient supabase = Supabase.instance.client;
//   late CalendarFormat _calendarFormat;
//   late DateTime _focusedDay;
//   late DateTime _selectedDay;
//   Map<DateTime, List<dynamic>> _events = {};
//   List<dynamic> _allAssignments = [];
//   List<dynamic> _selectedDayAssignments = [];
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _calendarFormat = CalendarFormat.month;
//     _focusedDay = DateTime.now();
//     _selectedDay = _focusedDay; // Initialize _selectedDay
//     _fetchAssignments(); // Fetch assignments when the page initializes
//   }
//
//   Future<void> _fetchAssignments() async {
//     final response = await supabase.from('assignments').select('*').execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch assignments');
//     }
//
//     final List assignments = response.data;
//     _events = {}; // Clear existing events
//     _allAssignments = assignments; // Store all assignments
//
//     assignments.forEach((assignment) {
//       DateTime deadline = DateTime.parse(assignment['deadline']);
//       if (_events.containsKey(deadline)) {
//         _events[deadline]!.add(assignment);
//       } else {
//         _events[deadline] = [assignment];
//       }
//     });
//
//     _filterAssignmentsForSelectedDay(); // Filter assignments for the selected day
//
//     setState(() {}); // Update UI after fetching assignments
//   }
//
//   void _filterAssignmentsForSelectedDay() {
//     _selectedDayAssignments = _allAssignments
//         .where((assignment) =>
//         isSameDay(DateTime.parse(assignment['deadline']), _selectedDay))
//         .toList();
//   }
//
//   List<dynamic> _getEventsForDay(DateTime day) {
//     return _events[day] ?? [];
//   }
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Color(0XFFFBCEB1),
//         elevation: 40.0,
//         title: const Padding(
//           padding: EdgeInsets.only(left: 60, bottom: 10),
//           child: Text('StudySensei', style: TextStyle(fontFamily: 'DancingScript', fontSize: 50, fontWeight: FontWeight.bold),),
//         ),
//       ),
//       body: _buildBody(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         items: const [
//            BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Calendar',
//           ),
//            BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'List',
//           ),
//            BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//       floatingActionButton: _currentIndex == 0
//           ? FloatingActionButton(
//                   onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddAssignmentPage()),
//           );
//           if (result == true) {
//             _fetchAssignments(); // Refresh assignments after adding new one
//           }
//                   },
//                   child: const Icon(Icons.add),
//                 )
//           : null,
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//
//   Widget _buildBody() {
//     switch (_currentIndex) {
//       case 0:
//         return _buildCalendarView();
//       case 1:
//         return _buildListView();
//       case 2:
//         return _buildSettingsView();
//       default:
//         return Container();
//     }
//   }
//
//   Widget _buildCalendarView() {
//     return Column(
//       children: [
//         TableCalendar(
//           firstDay: DateTime.utc(2021, 1, 1),
//           lastDay: DateTime.utc(2030, 12, 31),
//           focusedDay: _focusedDay,
//           selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//           calendarFormat: _calendarFormat,
//           onFormatChanged: (format) {
//             setState(() {
//               _calendarFormat = format;
//             });
//           },
//           headerStyle: const HeaderStyle(
//             formatButtonVisible: false, // Remove format button
//           ),
//           daysOfWeekStyle: const DaysOfWeekStyle(
//             weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
//             weekendStyle: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           calendarStyle: CalendarStyle(
//             todayDecoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.3),
//             ),
//             selectedDecoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//           eventLoader: (day) => _getEventsForDay(day),
//           onDaySelected: (selectedDay, focusedDay) {
//             setState(() {
//               _selectedDay = selectedDay;
//               _focusedDay = focusedDay; // Update focusedDay
//               _filterAssignmentsForSelectedDay(); // Filter assignments for the selected day
//             });
//           },
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _selectedDayAssignments.length,
//             itemBuilder: (context, index) {
//               final assignment = _selectedDayAssignments[index];
//               return _buildAssignmentCard(assignment);
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildListView() {
//     return ListView.builder(
//       itemCount: _allAssignments.length,
//       itemBuilder: (context, index) {
//         final assignment = _allAssignments[index];
//         return _buildAssignmentCard(assignment);
//       },
//     );
//   }
//
//   Widget _buildSettingsView() {
//     return const Center(
//       child: Text('Settings'),
//     );
//   }
//
//   Widget _buildAssignmentCard(dynamic assignment) {
//     return Dismissible(
//       key: Key(assignment['id'].toString()), // Unique key for each Dismissible widget
//       background: Container(
//         color: Colors.red,
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       direction: DismissDirection.endToStart,
//       onDismissed: (direction) async {
//         await _deleteAssignment(assignment['id']);
//         _fetchAssignments(); // Refresh assignments after deletion
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         child: ListTile(
//           title: Text(assignment['name']),
//           subtitle: Text('Subject: ${assignment['subject']}\nDeadline: ${assignment['deadline']}'),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _deleteAssignment(int id) async {
//     final response = await supabase.from('assignments').delete().eq('id', id).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to delete assignment');
//     }
//   }
// }
//