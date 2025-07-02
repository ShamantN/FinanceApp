import 'package:flutter/material.dart';

class PostOffice extends StatefulWidget {
  const PostOffice({super.key});

  @override
  State<PostOffice> createState() => _PostOfficeState();
}

class _PostOfficeState extends State<PostOffice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(),
      body: const CircularProgressIndicator(),
    );
  }
}
