import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Fin Mentor", style: TextStyle(color: Colors.white),),

        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                height: 200,
                width: 100,
                child: InkWell(
                  onTap: (){
                    print("On God, fr fr");
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("I love Homework!",
                        style: TextStyle(fontSize: 24, color: Colors.white),),
                      ],
                    ),
                  color: Colors.blue,),
                ),
              ),
            ),
            Container(
              height: 200,
              width: 100,

              child: InkWell(
                onTap: (){
                  print("Gimmie Somethin");
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("I don't like Homework!",
                      textAlign: TextAlign.center,

                      style: TextStyle(fontSize: 24, color: Color(0xFF171717)),),
                    ],
                  ),
                  color: Colors.blue,),
              ),
            ),
          ],
        ),
      )
    );
  }
}
