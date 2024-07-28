import 'package:CRUD/utils/mini_tools.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});
  @override
  State<ComingSoon> createState() => _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
  bool initialized = false;
  late Styles appStyle = Styles(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      appStyle;
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appStyle.appBar('Coming Soon'),
      body: appStyle.pageBorder(
       Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: appStyle.deviceWidth),
            const Text(
              'Coming Soon',
              style: TextStyle(fontSize: 32),
            ),
            const Gap(30),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'For More Information Checkout',
                style: TextStyle(fontSize: 22),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
                onPressed: ()=> 
                    MiniTool.launchUrl("https://github.com/Gabbar-v7/CRUD"),
                child: const Text('GitHub'))
          ],
        ),
      ),
    );
  }
}
