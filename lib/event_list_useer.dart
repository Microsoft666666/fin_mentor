// event_list_user.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/authentication.dart';

class EventListUser extends StatelessWidget {
  const EventListUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = AuthenticationHelper().uid;
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
            bool isSignedUp = signUps.contains(userId);
            return ListTile(
              title: Text(event['name']),
              subtitle: Text(event['info']),
              trailing: ElevatedButton(
                onPressed: isSignedUp
                    ? null
                    : () async {
                  await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                    'signUps': FieldValue.arrayUnion([userId]),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signed up for event')),
                  );
                },
                child: Text(isSignedUp ? 'Signed Up' : 'Sign Up'),
              ),
            );
          },
        );
      },
    );
  }
}
