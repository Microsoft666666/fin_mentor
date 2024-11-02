import 'package:fin_mentor/user/event_list_user.dart';
import 'package:fin_mentor/auth/loginPage.dart';
import 'package:fin_mentor/user/userHomepage.dart';
import 'package:fin_mentor/user/userResources.dart';
import 'package:flutter/material.dart';
import '../auth/authentication.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Track the selected index for navigation

  final List<Widget> _pageWidgets = [
    UserHomepage(),
    EventListUser(),
    UserResources(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index to show the page
    });
  }

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
        title: Text(
          'Fin Mentor Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
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
                          bool deleted = await AuthenticationHelper().deleteAccount(passwordController.text);
                          if (deleted) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
        ]
            : [],
      ),
      body: _pageWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Resources',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
       ),
    );
  }
}
