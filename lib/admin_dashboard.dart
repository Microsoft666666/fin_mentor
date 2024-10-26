// admin_dashboard.dart
import 'package:fin_mentor/event_form.dart';
import 'package:fin_mentor/event_list_admin.dart';
import 'package:fin_mentor/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logo.png'),
          ),
          title: Text('Admin Dashboard',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          actions: [
            IconButton(
                onPressed: () async {
                  TextEditingController passwordController =
                  TextEditingController();
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Account'),
                          content: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration:
                            InputDecoration(hintText: 'Enter password'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await AuthenticationHelper()
                                    .deleteAccount(passwordController.text);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      });
                  // AuthenticationHelper().deleteAccount();
                },
                icon: const Icon(Icons.delete)),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              opacity: 0.4,
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Expanded(child: EventForm()),
                Expanded(child: EventListAdmin()),
              ],
            ),
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
          label: Text('Add Event'),
          icon: Icon(Icons.event),
        ));
  }
}
