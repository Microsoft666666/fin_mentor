import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class AdminResources extends StatefulWidget {
  const AdminResources({Key? key}) : super(key: key);

  @override
  State<AdminResources> createState() => _AdminResourcesState();
}

class _AdminResourcesState extends State<AdminResources> {
  final pgFile =
  PdfControllerPinch(document: PdfDocument.openAsset('assets/CH1-IG.pdf'));

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
                      builder: (context) => PdfViewPinch(controller: pgFile)),
                );
              },
              child: const Card(
                color: Color.fromRGBO(204, 234, 211, 0.5),
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
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Your handbook for the next chapter.",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
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
