import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';

class EventListAdmin extends StatelessWidget {
  const EventListAdmin({Key? key}) : super(key: key);

  Future<void> _showParticipantsDialog(
      BuildContext context, List<dynamic> uids) async {
    List<Map<String, dynamic>> participants = [];

    for (var uid in uids) {
      // Fetch each user's details based on the uid
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Assuming the user document has 'firstName' and 'lastName' fields
        participants.add({
          'firstName': userDoc['firstname'],
          'lastName': userDoc['lastname'],
        });
      }
    }

    // Show dialog with participants
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Participants"),
          content: participants.isEmpty
              ? Text("No participants found.")
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: participants.map((participant) {
              return ListTile(
                title: Text(
                    "${participant['firstName']} ${participant['lastName']}"),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
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
                  child: ListTile(
                    leading: Icon(Icons.event, size: 40, color: EventApp.surfaceColor,),
                    title: Text(event['name'],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: EventApp.surfaceColor)),
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
                              color: EventApp.surfaceColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          WidgetSpan(
                            child: InkWell(
                              onTap: () => _showParticipantsDialog(
                                  context, signUps),
                              child: Text(
                                'Participants Who Registered: ',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '${signUps.length}',
                            style: TextStyle(
                              color: EventApp.surfaceColor,
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
