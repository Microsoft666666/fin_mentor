import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class AdminResources extends StatelessWidget {
  const AdminResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final igFile = PdfControllerPinch(
                  document: PdfDocument.openAsset('assets/CH1-IG.pdf'),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      title: "Instructor Guide",
                      controller: igFile,
                    ),
                  ),
                );
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
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                final slides = PdfControllerPinch(
                  document: PdfDocument.openAsset('assets/CH1-Slides.pdf'),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      title: "Instructor Slides",
                      controller: slides,
                    ),
                  ),
                );
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
                            "Get ready for the next class",
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

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final PdfControllerPinch controller;

  const PdfViewerScreen({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PdfViewPinch(controller: controller),
    );
  }
}
