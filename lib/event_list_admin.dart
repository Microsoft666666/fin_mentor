// event_list_admin.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventListAdmin extends StatelessWidget {
  const EventListAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final events = snapshot.data!.docs;
        return ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                DocumentSnapshot event = events[index];
                List<dynamic> signUps = event['signUps'] ?? [];
                return Card(
                  color: Color.fromRGBO(204, 234, 211, 0.5019607843137255),
                  child: ListTile(
                    leading: Icon(Icons.event, size: 40),
                    title: Text(event['name'],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    // subtitle: Text('Sign-Ups: ${signUps.length}'), change to richtext
                    subtitle: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text:
                            'Date: ${DateTime.fromMillisecondsSinceEpoch(event['date']).toString().substring(0, 16)}\n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              text: 'Participants Who Register: ',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                            text: '${signUps.length}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 100),
          ],
        );
      },
    );
  }
}
