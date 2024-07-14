import 'package:flutter/material.dart';
import 'package:studysensei/services/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAssignmentPage extends StatefulWidget {
  @override
  _AddAssignmentPageState createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedSubject = 'Maths'; // Default selected subject
  DateTime _deadline = DateTime.now();
  final SupabaseClient supabase = Supabase.instance.client;

  final List<String> subjects = [
    'Maths',
    'Science',
    '2nd Language',
    'English',
    'Social Science',
    'AI'
  ];

  final Map<String, Color> subjectColors = {
    'Maths': SubjectColors.red,
    'Science': SubjectColors.green,
    '2nd Language': SubjectColors.orange,
    'English': SubjectColors.pink,
    'Social Science': SubjectColors.purple,
    'AI': SubjectColors.teal,
  };

  void _saveAssignment() async {
    if (_formKey.currentState!.validate()) {
      final newAssignment = {
        'name': _nameController.text,
        'subject': _selectedSubject,
        'deadline': _deadline.toIso8601String(),
      };

      final response = await supabase.from('assignments').insert(newAssignment).execute();
      if (response.error == null) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.error!.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(
                      subject,
                      style: TextStyle(color: subjectColors[subject]),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubject = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a subject';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Deadline: ${_deadline.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAssignment,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }
}
