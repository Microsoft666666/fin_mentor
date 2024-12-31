import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';

class EventListAdmin extends StatelessWidget {
  const EventListAdmin({Key? key}) : super(key: key);

  /// Fetch participant info from Firestore based on a list of UIDs
  Future<List<Map<String, dynamic>>> _fetchParticipants(List<dynamic> uids) async {
    List<Map<String, dynamic>> participants = [];
    for (var uid in uids) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        participants.add({
          'firstName': userDoc['firstname'],
          'lastName': userDoc['lastname'],
        });
      }
    }
    return participants;
  }

  Future<void> _showParticipantsBottomSheet(
      BuildContext context,
      List<dynamic> uids,
      ) async {
    showModalBottomSheet(
      context: context,
      // Allows the bottom sheet to go full screen if needed
      isScrollControlled: true,
      // Rounded corners at the top
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchParticipants(uids),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Still loading data -> show a progress indicator
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final participants = snapshot.data ?? [];
            // Create a list of TextEditingControllers, one for each participant
            final controllers = List.generate(
              participants.length,
                  (_) => TextEditingController(),
            );

            return Padding(
              // Ensure the bottom sheet avoids system insets (keyboard, etc.)
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "Participants",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (participants.isEmpty)
                      const Text("No participants found.")
                    else
                    // Show the participants + hours field
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: participants.asMap().entries.map((entry) {
                          final index = entry.key;
                          final participant = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${participant['firstName']} ${participant['lastName']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Number of hours participated",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),

                    // Close button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Close"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final signUps = event['signUps'] ?? [];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.event,
                      size: 40,
                      color: EventApp.surfaceColor,
                    ),
                    title: Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: EventApp.surfaceColor,
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: const TextStyle(
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
                              onTap: () => _showParticipantsBottomSheet(
                                context,
                                signUps,
                              ),
                              child: const Text(
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
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }
}
