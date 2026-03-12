import 'package:flutter/material.dart';
import 'core/services/supabase_service.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  runApp(const ExpensesTrackApp());
}

class ExpensesTrackApp extends StatelessWidget {
  const ExpensesTrackApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expenses Tracker",
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );

  }
}