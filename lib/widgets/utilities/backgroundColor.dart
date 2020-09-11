import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[900],
      ),
    );
  }
}
