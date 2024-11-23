import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class AdminResources extends StatefulWidget {
  const AdminResources({Key? key}) : super(key: key);

  @override
  State<AdminResources> createState() => _AdminResourcesState();
}

class _AdminResourcesState extends State<AdminResources> {
  final igFile =
  PdfControllerPinch(document: PdfDocument.openAsset('assets/CH1-IG.pdf'));
  final slides = PdfControllerPinch(document: PdfDocument.openAsset('assets/CH1-Slides.pdf'));

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewPinch(controller: igFile)),
                );
              },
              child: Card(

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
                            "Instructor Guide",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold, color: EventApp.surfaceColor),
                          ),
                          Text(
                            "Your handbook for the next chapter.",
                            style: TextStyle(fontSize: 15, color: EventApp.surfaceColor),
                          )
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: EventApp.surfaceColor,
                        size: 50,
                      )
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewPinch(controller: slides)),
                );
              },
              child: Card(
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
                            "Instructor Slides",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold, color: EventApp.surfaceColor),
                          ),
                          Text(
                            "Get ready for the next class",
                            style: TextStyle(fontSize: 15, color: EventApp.surfaceColor),
                          )
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: EventApp.surfaceColor,
                        size: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
