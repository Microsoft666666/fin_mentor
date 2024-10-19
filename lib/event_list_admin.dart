// event_list_admin.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListAdmin extends StatelessWidget {
  const EventListAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').orderBy('date').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            DocumentSnapshot event = events[index];
            List<dynamic> signUps = event['signUps'] ?? [];
            return ListTile(
              title: Text(event['name']),
              subtitle: Text('Sign-Ups: ${signUps.length}'),
            );
          },
        );
      },
    );
  }
}
