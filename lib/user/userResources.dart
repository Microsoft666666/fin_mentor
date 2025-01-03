import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class UserResources extends StatefulWidget {
  const UserResources({super.key});

  @override
  State<UserResources> createState() => _UserResourcesState();
}

class _UserResourcesState extends State<UserResources> {
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
                // Create a new PdfControllerPinch instance each time
                final PdfControllerPinch pgFile = PdfControllerPinch(
                  document: PdfDocument.openAsset('assets/CH1-PG.pdf'),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(controller: pgFile),
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
                          )
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

  const PdfViewerScreen({super.key, required this.controller});

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
