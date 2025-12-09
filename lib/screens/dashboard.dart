import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final dynamic uid;

  const Dashboard({super.key,required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}