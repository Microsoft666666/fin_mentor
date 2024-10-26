// user_dashboard.dart
import 'package:fin_mentor/event_list_useer.dart';
import 'package:fin_mentor/loginPage.dart';
import 'package:flutter/material.dart';

import 'components/authentication.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await AuthenticationHelper().signOut();
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
        title: Text('Fin Mentor Events',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
        actions: AuthenticationHelper().user != null
            ? [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => _logout(context),
                ),
          IconButton(
            onPressed: () async {
              TextEditingController passwordController = TextEditingController();
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Account'),
                      content: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'Enter password'),
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
                            bool deleted = await AuthenticationHelper()
                                .deleteAccount(passwordController.text);
                            if (deleted) {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.delete),
          ),
              ]
            : [],
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
            child: EventListUser(),
          )),
    );
  }
}
