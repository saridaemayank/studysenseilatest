// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AddAssignmentPage extends StatefulWidget {
//   @override
//   _AddAssignmentPageState createState() => _AddAssignmentPageState();
// }
//
// class _AddAssignmentPageState extends State<AddAssignmentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _subjectController = TextEditingController();
//   DateTime _deadline = DateTime.now();
//   final SupabaseClient supabase = Supabase.instance.client;
//
//   void _saveAssignment() async {
//     if (_formKey.currentState!.validate()) {
//       final newAssignment = {
//         'name': _nameController.text,
//         'subject': _subjectController.text,
//         'deadline': _deadline.toIso8601String(),
//       };
//
//       final response = await supabase.from('assignments').insert(newAssignment).execute();
//       if (response.error == null) {
//         Navigator.pop(context, true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.error!.message}')));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Assignment'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _subjectController,
//                 decoration: InputDecoration(labelText: 'Subject'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the subject';
//                   }
//                   return null;
//                 },
//               ),
//               ListTile(
//                 title: Text('Deadline: ${_deadline.toLocal()}'),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: _pickDate,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveAssignment,
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _deadline,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _deadline) {
//       setState(() {
//         _deadline = picked;
//       });
//     }
//   }
// }