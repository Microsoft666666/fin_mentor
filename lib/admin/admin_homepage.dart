import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/authentication.dart';
import '../auth/loginPage.dart';
import 'event_form.dart';
import 'event_list_admin.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({Key? key}) : super(key: key);

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            opacity: 0.4,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: EventListAdmin()),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventForm()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        label: const Text('Add Event'),
        icon: const Icon(Icons.event),
      ),
    );
  }
}
