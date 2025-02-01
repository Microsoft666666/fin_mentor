import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class UserResources extends StatelessWidget {
  const UserResources({Key? key}) : super(key: key);

  Future<File> _getCachedFile(String filePath, String fileUrl) async {
    final dir = await getTemporaryDirectory();
    final localFile = File('${dir.path}/$filePath');

    // If file exists locally, return it; otherwise, download it.
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
    return Center(
      child: Column(
        children: [
          // Participant Guide
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading...')),
                );
                // Direct download URL for the PDF.
                const fileUrl =
                    'https://firebasestorage.googleapis.com/v0/b/fin-mentor.firebasestorage.app/o/Participant%2FParticipant%20Guide.pdf?alt=media&token=4b095aa6-1acf-4053-9609-9bea8a5f45d4';
                const fileName = 'Participant Guide.pdf';
                const folder = 'Participant';
                final cachedFile = await _getCachedFile(
                  '$folder/$fileName',
                  fileUrl,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
  const PdfViewerScreen({Key? key, required this.title, required this.controller}) : super(key: key);

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
