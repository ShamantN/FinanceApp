// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

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
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => filePath));
          print("hello world");
        },
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(imgPath),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white)),
          ),
        ),
      ),
    ]);
  }
}
