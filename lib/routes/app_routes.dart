import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart'; // 👈 NEW
import '../features/dashboard/screens/main_navigation.dart';

import 'route_names.dart';

class AppRoutes {

  static const login = RouteNames.login;

  static Map<String, WidgetBuilder> routes = {

    RouteNames.login: (context) => const LoginScreen(),

    RouteNames.signup: (context) => const SignupScreen(),

    RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(), // 👈 NEW

    // Dashboard ab MainNavigation se open hoga
    RouteNames.dashboard: (context) => const MainNavigation(),

  };

}