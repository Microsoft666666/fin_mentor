import 'package:fin_mentor/components/authentication.dart';
import 'package:fin_mentor/dashboard.dart';
import 'package:fin_mentor/loginPage.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try{
      await Future.delayed(Duration(seconds: 2));
      bool isLoggedIn = await AuthenticationHelper().isLoggedIn();

      if(isLoggedIn)
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Dashboard()));
      }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Dashboard()));
      }

    }catch (e) {
      print('Error during initialization $e');
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Dashboard()));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Text(
                  //   'Fin Mentor',
                  //
                  // ),
                  const Spacer(),
                  // Container(
                  //   height: 180,
                  //   width: 200,
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/icons/logo.png'),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset('assets/logo.png'),
                      )),
                  const Spacer(),
                  const Column(
                    children: [
                      Text(
                        'Version',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 630,
            )
          ],
        ),
      ),
    );
  }
}