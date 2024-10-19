// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fin_mentor/dashboard.dart';
import 'package:fin_mentor/loginPage.dart';
import 'package:fin_mentor/admin_dashboard.dart';
import 'package:fin_mentor/user_dashboard.dart';
import 'components/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
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
      setState(() {}); // Update UI when user changes
    });
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
