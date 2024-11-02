// main.dart
import 'package:fin_mentor/admin/admin_dashboard.dart';
import 'package:fin_mentor/auth/loginPage.dart';
import 'package:fin_mentor/user/user_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/authentication.dart';
import 'auth/firebase_options.dart';
import 'material_theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialTheme customTheme = MaterialTheme(TextTheme());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event App',
      theme: customTheme.theme(MaterialTheme.lightMediumContrastScheme()),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final AuthenticationHelper _authHelper = AuthenticationHelper();

  @override
  void initState() {
    super.initState();
    _authHelper.userChanges().listen((user) {
      // Update UI when user changes
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    if (_authHelper.user != null) {
      // User is logged in, check if admin
      if (_authHelper.isAdmin) {
        return AdminDashboard();
      } else {
        return UserDashboard();
      }
    } else {
      // User is not logged in
      return LoginPage();
    }
  }
}
