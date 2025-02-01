import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';

import '../auth/authentication.dart';
import '../main.dart'; // Ensure this imports your `EventApp` class correctly.

class EventListUser extends StatefulWidget {
  EventListUser({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventListUserState();
}

class _EventListUserState extends State<EventListUser> {
  List<bool> isMoreInfoList = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = AuthenticationHelper().user?.uid;
  }

  // Helper function: checks if the file exists in cache; if not, downloads it.
  Future<File> _getCachedFile(String filePath, String fileUrl) async {
    final dir = await getTemporaryDirectory();
    final localFile = File('${dir.path}/$filePath');

    if (await localFile.exists()) {
      return localFile;
    } else {
      final dio = Dio();
      await dio.download(fileUrl, localFile.path);
      return localFile;
    }
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

        if (isMoreInfoList.length != events.length) {
          isMoreInfoList = List.filled(events.length, false);
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final data = event.data() as Map<String, dynamic>?;

            if (data == null) {
              return const SizedBox.shrink(); // Skip invalid data.
            }

            final List<dynamic> signUps = data['signUps'] ?? [];
            final bool isSignedUp = signUps.contains(userId);

            return Card(
              child: ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    isMoreInfoList[index] = !isMoreInfoList[index];
                  });
                },
                title: Text(
                  "🗓️ ${data['name'] ?? 'Unnamed Event'}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: EventApp.surfaceColor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${data['date'] != null ? DateTime.fromMillisecondsSinceEpoch(data['date']).toString().substring(0, 16) : 'Unknown Date'}',
                      style: TextStyle(
                        color: EventApp.surfaceColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      !isMoreInfoList[index] ? 'More Info' : 'Less Info',
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                    Icon(
                      !isMoreInfoList[index]
                          ? Icons.keyboard_arrow_down_outlined
                          : Icons.keyboard_arrow_up_outlined,
                    ),
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
                            text: data['info'] ?? 'No information available.',
                            style: TextStyle(
                              color: EventApp.surfaceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Referenced Pages Section
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        // Define file parameters.
                        const fileName = "Participant Guide.pdf";
                        const folder = 'Participant'; // Replace with your actual folder name.
                        const fileUrl =
                            'https://firebasestorage.googleapis.com/v0/b/fin-mentor.firebasestorage.app/o/Participant%2FParticipant%20Guide.pdf?alt=media&token=4b095aa6-1acf-4053-9609-9bea8a5f45d4';
                        final filePath = '$folder/$fileName';

                        // Check if the file is already cached.
                        final tempDir = await getTemporaryDirectory();
                        final localFile = File('${tempDir.path}/$filePath');

                        // Show "Downloading..." SnackBar if the file isn’t cached.
                        if (!await localFile.exists()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading...')),
                          );
                        }

                        // Retrieve the cached file (or download it).
                        final cachedFile = await _getCachedFile(filePath, fileUrl);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        // Determine the initial page from the event data.
                        final dynamic pageFromValue = data["pageFrom"];
                        final int initialPage = (pageFromValue is String)
                            ? (int.tryParse(pageFromValue) ?? 0)
                            : (pageFromValue is int ? pageFromValue : 0);

                        // Create the PDF controller with the specified initial page.
                        final pdfController = PdfControllerPinch(
                          initialPage: initialPage,
                          document: PdfDocument.openFile(cachedFile.path),
                        );

                        // Open the PDF viewer page, passing the initialPage.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              title: "PDF Viewer",
                              controller: pdfController,
                              initialPage: initialPage,
                            ),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Referenced Pages:\n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: data.containsKey('pageFrom') && data.containsKey('pageTo')
                                  ? '${data['pageFrom']}-${data['pageTo']}'
                                  : 'N/A',
                              style: TextStyle(
                                color: EventApp.surfaceColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                      const SnackBar(
                        content: Text('Signed up for event'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return EventApp.accentColor;
                        }
                        return Theme.of(context).primaryColor;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white;
                        }
                        return Colors.white;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  child: Text(
                    isSignedUp ? 'Signed Up' : 'Sign Up',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : const Text(
                  'Sign Up to\njoin events',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final PdfControllerPinch controller;
  final String title;
  final int initialPage;

  const PdfViewerScreen({
    Key? key,
    required this.title,
    required this.controller,
    required this.initialPage,
  }) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
    // After the first frame, force jump to the desired page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.jumpToPage(widget.initialPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PdfViewPinch(controller: widget.controller),
    );
  }
}
