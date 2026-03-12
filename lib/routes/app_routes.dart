import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/dashboard/screens/main_navigation.dart';

import 'route_names.dart';

class AppRoutes {

  static const login = RouteNames.login;

  static Map<String, WidgetBuilder> routes = {

    RouteNames.login: (context) => const LoginScreen(),

    RouteNames.signup: (context) => const SignupScreen(),

    // Dashboard ab MainNavigation se open hoga
    RouteNames.dashboard: (context) => const MainNavigation(),

  };

}