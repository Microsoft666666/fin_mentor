// admin_dashboard.dart
import 'package:fin_mentor/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fin_mentor/event_form.dart';
import 'package:fin_mentor/event_list_admin.dart';
import 'components/authentication.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    AuthenticationHelper().isAdmin = false;
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: EventForm()),
          Expanded(child: EventListAdmin()),
        ],
      ),
    );
  }
}
