import 'package:flutter/material.dart';

class foodpixels extends StatelessWidget {
  const foodpixels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2),
        ),

      ),
    );
  }
}
