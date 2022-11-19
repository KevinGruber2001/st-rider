import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rider/pages/driver/driver.dart';
import 'package:rider/repo/assignment_repo.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  bool driverAccepted = false;
  bool disposed = false;
  int checkCounter = 0;

  @override
  void initState() {
    checkIfDriverAccepts();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  checkIfDriverAccepts() async {
    while (!driverAccepted && !disposed) {
      bool temp = await AssignmentRepo().fetchAssignment();
      log("temp");
      log(temp.toString());
      if (temp == true) {
        setState(() {
          driverAccepted = true;
        });
      } else {
        setState(() {
          checkCounter = checkCounter + 1;
        });
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (driverAccepted) {
      return Driver();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Waiting for drivers to accept. Counter = " +
                checkCounter.toString()),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  disposed = true;
                });
                await AssignmentRepo().cancelRequest();
                Navigator.of(context).pop();
              },
              child: Text("Return"),
            )
          ],
        ),
      ),
    );
  }
}
