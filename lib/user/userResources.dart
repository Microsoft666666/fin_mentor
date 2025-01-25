import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class UserResources extends StatelessWidget {
  const UserResources({Key? key}) : super(key: key);

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

  Future<String?> _getFileUrl(String folder, String fileName) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('resources')
          .doc(folder)
          .get();
      return doc[fileName];
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Participant Guide
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final fileName = 'Participant Guide.pdf';
                final folder = 'Participant';
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
                        title: "Participant Guide",
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
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Participant Guide",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Your handbook for the next chapter.",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, size: 50, color: Colors.white),
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

class PdfViewerScreen extends StatelessWidget {
  final PdfControllerPinch controller;
  final String title;
  const PdfViewerScreen({super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: PdfViewPinch(controller: controller),
    );
  }
}
