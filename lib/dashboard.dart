import 'package:fin_mentor/eventsPage.dart';
import 'package:fin_mentor/homePage.dart';
import 'package:fin_mentor/profilePage.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPageIndex = 0;
  double progress = 0.152;
  final List<Widget> pages = [
    HomePage(),
    EventsPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title:
        const Text('Fin Mentor', style: TextStyle(fontFamily: 'Raleway')),
        backgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).surface
      ),
      body: pages[selectedPageIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Color(0x35000000), spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
          child: NavigationBar(
            backgroundColor: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).surface,
            indicatorColor: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).secondary,
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    color: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).primary,
                  ),
                  label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.explore, color: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).secondary),
                  label: 'Explore'),
              NavigationDestination(
                  icon: Icon(Icons.account_circle, color: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent).secondary),
                  label: 'Profile')
            ],
            selectedIndex: selectedPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
            animationDuration: Duration(milliseconds: 1000),
          ),
        ),
      ),
    );
  }
}