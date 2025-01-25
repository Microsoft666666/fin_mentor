import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fin_mentor/main.dart';
import 'package:fin_mentor/user/userResources.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class AdminResources extends StatelessWidget {
  const AdminResources({Key? key}) : super(key: key);

  Future<File> _getCachedFile(String filePath, String fileUrl) async {
    final dir = await getTemporaryDirectory();
    final localFile = File('${dir.path}/$filePath');

    // If file exists locally, return it; otherwise, download it
    if (await localFile.exists()) {
      return localFile;
    } else {
      final dio = Dio();
      await dio.download(fileUrl, localFile.path);
      return localFile;
    }
  }

  Future<String?> _getFileUrl(String folder, String fileName) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('resources')
          .doc(folder)
          .get();
      return doc[fileName];
    } catch (e) {
      return null; // Return null if the file URL can't be fetched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Instructor Guide
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final fileName = 'Instructor Guide.pdf';
                final folder = 'Admin';
                final fileUrl = await _getFileUrl(folder, fileName);

                if (fileUrl != null) {
                  final cachedFile = await _getCachedFile(
                    '$folder/$fileName',
                    fileUrl,
                  );

                  final controller = PdfControllerPinch(
                    document: PdfDocument.openFile(cachedFile.path),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        title: "Instructor Guide",
                        controller: controller,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to load PDF.')),
                  );
                }
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Instructor Guide",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: EventApp.surfaceColor,
                            ),
                          ),
                          Text(
                            "Your handbook for the next chapter.",
                            style: TextStyle(
                              fontSize: 15,
                              color: EventApp.surfaceColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: EventApp.surfaceColor,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Slides
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final fileName = 'Slides.pdf';
                final folder = 'Admin';
                final fileUrl = await _getFileUrl(folder, fileName);

                if (fileUrl != null) {
                  final cachedFile = await _getCachedFile(
                    '$folder/$fileName',
                    fileUrl,
                  );

                  final controller = PdfControllerPinch(
                    document: PdfDocument.openFile(cachedFile.path),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        title: "Instructor Slides",
                        controller: controller,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to load PDF.')),
                  );
                }
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Instructor Slides",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: EventApp.surfaceColor,
                            ),
                          ),
                          Text(
                            "Get ready for the next class.",
                            style: TextStyle(
                              fontSize: 15,
                              color: EventApp.surfaceColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: EventApp.surfaceColor,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
