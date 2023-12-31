import 'package:CRUD/logic/splash.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Runs as soon as class is initialized
  @override
  void initState() {
    super.initState();
    // Change to homepage
    changePage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Image.asset(
                    '_res/ic_launcher.png',
                    width: 65,
                  ),
                ),
                Text(
                  'CRUD',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 69),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                'Create, Read, Update, Delete',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          ]),
    );
  }
}
