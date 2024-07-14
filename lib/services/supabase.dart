import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials {
  static const String supabaseUrl = 'https://jygkmgonyiufvphaqieb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5Z2ttZ29ueWl1ZnZwaGFxaWViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA1MzIxNzUsImV4cCI6MjAzNjEwODE3NX0.x4y1gYHugeFsPfjO-WbCMjR7d78cg2iLUwdl3js2XvQ';
}

void initSupabase() {
  Supabase.initialize(
    url: SupabaseCredentials.supabaseUrl,
    anonKey: SupabaseCredentials.supabaseAnonKey,
  );
}