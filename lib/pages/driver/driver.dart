import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Driver extends StatelessWidget {
  const Driver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your driver is arriving"),
            SizedBox(
              height: 20,
            ),
            Text(style: TextStyle(fontSize: 30), "SOON")
          ],
        ),
      ),
    );
  }
}
