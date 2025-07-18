// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Options extends StatelessWidget {
  final String title;
  final String imgPath;
  final Widget filePath;

  const Options(
      {super.key,
      required this.title,
      required this.imgPath,
      required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => filePath));
        },
        child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.darken),
                ),
                borderRadius: BorderRadius.circular(32)),
            child: const SizedBox()),
      ),
      Center(
        child: Text(title,
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black)),
      ),
    ]);
  }
}
