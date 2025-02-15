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

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final PdfControllerPinch controller;

  const PdfViewerScreen({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = widget.controller;
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfController,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 200)), // Ensure some delay before rendering
        builder: (context, snapshot) {
          return PdfViewPinch(
            controller: _pdfController,
            builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(),
              documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
              pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, error) =>
                  Center(child: Text(error.toString())),
            ),
          );
        },
      ),
    );
  }
}

