import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
class UserResources extends StatefulWidget {
  const UserResources({super.key});

  @override
  State<UserResources> createState() => _UserResourcesState();
}

class _UserResourcesState extends State<UserResources> {
  final pgFile = PdfControllerPinch(document: PdfDocument.openAsset('assets/CH1-PG.pdf'));
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 150,
            margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: ()async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPinch(controller: pgFile)));

              },
              child: const Card(
                  color: const Color.fromRGBO(204, 234, 211, 0.5019607843137255),
                  child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Participant Guide",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text("Your handbook for the next chapter.",
                          style: TextStyle(fontSize: 15),)
                        ],
                      ),
                      Icon(Icons.chevron_right, size: 50,)
                    ],
                  ),
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
