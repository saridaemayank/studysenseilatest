import 'package:flutter/material.dart';
import 'package:studysensei/pages/assignments_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase.dart';

void main() {
  initSupabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssignmentPage(),
    );
  }
}

