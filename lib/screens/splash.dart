import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final appLinks = AppLinks(); 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appLinks.uriLinkStream.listen((event) {
      print(event);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 51, 78, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app/main.png', height: 200),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
