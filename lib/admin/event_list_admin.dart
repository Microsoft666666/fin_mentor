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
      ) async {
    // We convert the event date in milliseconds to a nice key, e.g. "2024-01-05"
    final dateTime = DateTime.fromMillisecondsSinceEpoch(eventDateMillis);
    final dateKey = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

    showModalBottomSheet(
      context: context,
      // Allows the sheet to expand if content is tall
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchParticipants(uids),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Still loading data => show progress
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            final participants = snapshot.data ?? [];
            // Create one text controller per participant (for hours).
            final controllers = List.generate(
              participants.length,
                  (_) => TextEditingController(),
            );

            return Padding(
              // Ensure bottom sheet avoids system insets
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
                    // Show participants + hours field
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                                  ],
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

                    // Space before action buttons
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          // "Close" button
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close"),
                        ),
                        ElevatedButton(
                          // "Submit" button
                          onPressed: participants.isNotEmpty
                              ? () async {
                            // Update each participant's doc in Firestore
                            for (int i = 0; i < participants.length; i++) {
                              final uid = participants[i]['uid'];
                              final hoursText = controllers[i].text.trim();
                              if (hoursText.isEmpty) continue;

                              final hours = double.tryParse(hoursText) ?? 0.0;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .set({
                                'participation_log': {
                                  dateKey: hours,
                                }
                              }, SetOptions(merge: true));
                            }

                            // After updating, close the bottom sheet
                            Navigator.of(context).pop();
                          }
                              : null, // If no participants, do nothing
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
