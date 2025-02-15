import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventListAdmin extends StatelessWidget {
  const EventListAdmin({Key? key}) : super(key: key);

  /// Fetch participant info from Firestore based on a list of UIDs
  /// and return a list of maps containing { uid, firstName, lastName }.
  Future<List<Map<String, dynamic>>> _fetchParticipants(List<dynamic> uids) async {
    final participants = <Map<String, dynamic>>[];
    for (var uid in uids) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        participants.add({
          'uid': uid,
          'firstName': userDoc['firstname'],
          'lastName': userDoc['lastname'],
        });
      }
    }
    return participants;
  }

  /// Show bottom sheet with participant data for the given event date.
  /// `eventDateMillis` is the millisecondsSinceEpoch for the event date.
  Future<void> _showParticipantsBottomSheet(
      BuildContext context,
      List<dynamic> uids,
      int eventDateMillis,
      String eventId,
      ) async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();

    final participantsData = await _fetchParticipants(uids);

    // Ensure participation_hours is a map
    Map<String, dynamic> participationData = {};
    if (eventDoc.exists && eventDoc.data()?.containsKey('participation_hours') == true) {
      participationData = Map<String, dynamic>.from(eventDoc.data()!['participation_hours']);
    }

    final controllers = <String, TextEditingController>{};

    for (var participant in participantsData) {
      final uid = participant['uid'];
      final storedHours = participationData[uid]?.toString() ?? '';
      controllers[uid] = TextEditingController(text: storedHours);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
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
                const Text(
                  "Participants",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                if (participantsData.isEmpty)
                  const Text("No participants found.")
                else
                  Column(
                    children: participantsData.map((participant) {
                      final uid = participant['uid'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${participant['firstName']} ${participant['lastName']}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                              ],
                              controller: controllers[uid],
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                    ElevatedButton(
                      onPressed: participantsData.isNotEmpty
                          ? () async {
                        final updatedData = Map<String, dynamic>.from(participationData);

                        for (var participant in participantsData) {
                          final uid = participant['uid'];
                          final hoursText = controllers[uid]?.text.trim();
                          if (hoursText?.isEmpty ?? true) continue;

                          final hours = double.tryParse(hoursText!) ?? 0.0;
                          updatedData[uid] = hours; // Update the map with the new value
                        }

                        await FirebaseFirestore.instance
                            .collection('events')
                            .doc(eventId)
                            .set({
                          'participation_hours': updatedData, // Ensure it's stored as a map
                        }, SetOptions(merge: true));

                        Navigator.of(context).pop();
                      }
                          : null,
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                // signUps is the list of user UIDs
                final signUps = event['signUps'] ?? [];
                final eventDateMillis = event['date']; // Store as int

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
                                eventDateMillis,
                                event.id

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
