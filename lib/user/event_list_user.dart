import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';

import '../auth/authentication.dart';

class EventListUser extends StatefulWidget {
  EventListUser({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EventListUserState();
  }
}

class _EventListUserState extends State<EventListUser> {
  List<bool> isMoreInfoList =[];
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = AuthenticationHelper().user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final events = snapshot.data!.docs;
        if (isMoreInfoList.length != events.length) {
          isMoreInfoList = List.filled(events.length, false);
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            DocumentSnapshot event = events[index];
            List<dynamic> signUps = event['signUps'] ?? [];
            bool isSignedUp = signUps.contains(userId);

            return Card(

              child: ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    isMoreInfoList[index] = !isMoreInfoList[index];
                    print(isMoreInfoList[index]);
                  });
                },
                // leading: Icon(Icons.event, size: 25),
                title: Text( "🗓️ ${event['name']}",
                    style:  TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: EventApp.surfaceColor)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Date: ${DateTime.fromMillisecondsSinceEpoch(event['date']).toString().substring(0, 16)}',
                        style:  TextStyle(color: EventApp.surfaceColor, fontSize: 16)),
                    Text(!isMoreInfoList[index] ? 'More Info' : 'Less Info',
                        style: const TextStyle(color: Colors.blueAccent)),
                    Icon(!isMoreInfoList[index]
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined),
                  ],
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Event Info:\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: event['info'],
                            style: TextStyle(
                              color: EventApp.surfaceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                trailing: AuthenticationHelper().user != null
                    ? ElevatedButton(
                  onPressed: isSignedUp
                      ? null
                      : () async {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .update({
                      'signUps': FieldValue.arrayUnion([userId]),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed up for event')),q
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSignedUp
                        ? Theme.of(context).primaryColor.withOpacity(0.7) // Brighter disabled color
                        : Theme.of(context).primaryColor, // Active state
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button padding
                  ),
                  child: Text(
                    isSignedUp ? 'Signed Up' : 'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : Text(
                  'Sign Up to\njoin events',
                  style: const TextStyle(fontSize: 14),
                ),

              ),
            );
          },
        );
      },
    );
  }
}
