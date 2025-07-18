// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final FirebaseAuth authInst = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInst = FirebaseFirestore.instance;

  final List<String> countires = [
    'India',
    'China',
    'Russia',
    'USA',
    'Australia'
  ];

  String? selectedCountry;
  DateTime? selectedDate;
  File? _image;

  Future<void> pickImage(ImageSource imgSrc) async {
    final pickedImage = await ImagePicker().pickImage(source: imgSrc);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String> uploadImage() async {
    if (_image == null) return '';
    try {
      // .ref() is the starting point for storage operations
      // .ref('images') will point to the images folder within the storage bucket
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = FirebaseStorage.instance.ref('images').child(fileName);
      final uploadTask = imageRef.putFile(
          _image!); //uploadTask represents the entire upload process, it gives control over starting,pausing,cancelling the task that is taking place
      final taskSnapshot = await uploadTask.whenComplete(() =>
          null); // taskSnapshot provides progress info(no. of bytes uploaded, total no of bytes, current state of task)

      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Picture uploaded successfully')));
      return downloadURL;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> updateUserData() async {
    try {
      final userUid = authInst.currentUser!.uid;
      final user = firestoreInst.collection("userInfo").doc(userUid);
      //final imageURL = await uploadImage();
      await user.update({
        'phone': _phoneCtrl.text.trim(),
        'dob': selectedDate,
        'country': selectedCountry,
        //'imageURL': imageURL.isNotEmpty ? imageURL : ''
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserData() async {
    try {
      final userUid = authInst.currentUser!.uid;
      final docSnapshot =
          await firestoreInst.collection("userInfo").doc(userUid).get();
      final userData = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameCtrl.text = userData['name'];
        _emailCtrl.text = userData['email'];
        _phoneCtrl.text = userData['phone'];
        selectedCountry = userData['country'] as String;
        final ts = userData['dob'] as Timestamp;
        selectedDate = ts.toDate();
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF0B0F33), // deep navy blue
          Color(0xFF1C1F6B), // indigo-blue
          Color(0xFF2C3E91), // rich blue
          Color(0xFF5369D6),
        ], stops: [
          0.0,
          0.4,
          0.75,
          1.0
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        bottomNavigationBar: CustomNavBar(navIndex: 3),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 40,
              )),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.black,
                    child: GestureDetector(
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                      },
                      child: CircleAvatar(
                        radius: 86,
                        backgroundImage: AssetImage('assets/photos/pp.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      right: -5,
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                        },
                        icon: Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      )),
                  Positioned(
                      bottom: 20,
                      right: 140,
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                        },
                        icon: Icon(Icons.add_photo_alternate,
                            color: Colors.white, size: 30),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23, bottom: 6),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _nameCtrl,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.badge, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 2)),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "E-Mail",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 2)),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      controller: _phoneCtrl,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.numbers, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 2)),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      controller: _pwdCtrl,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.password,
                            color: Colors.white,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white70, width: 2)),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Date of Birth",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DOBInputField(
                      initialDate: selectedDate ?? DateTime(1900, 1, 1),
                      cursorColor: Colors.white,
                      dateFormatType: DateFormatType.DDMMYYYY,
                      style: TextStyle(color: Colors.white),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      showLabel: true,
                      showCursor: true,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSubmitted: (date) {
                        setState(() {
                          selectedDate = date;
                          _dobCtrl.text =
                              "${date.day}/${date.month}/${date.year}";
                        });
                      },
                      inputDecoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white70),
                        labelText: "Press enter after filling in your DOB",
                        labelStyle: TextStyle(fontSize: 12),
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 2)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, bottom: 6, top: 10),
                    child: Text(
                      "Country",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DropdownButtonFormField(
                      hint: Text(
                        "Select your country",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.grey,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconEnabledColor: Colors.white,
                      value: selectedCountry,
                      items: countires
                          .map((country) => DropdownMenuItem<String>(
                                value: country,
                                child: Text(
                                  country,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCountry = newVal.toString();
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 45, 255, 157)
                                        .withOpacity(0.5),
                                    spreadRadius: 8,
                                    blurRadius: 16,
                                    offset: Offset(0, 0)),
                              ],
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6A11CB),
                                    Color(0xFF4056D4),
                                    Color(0xFF2575FC),
                                  ],
                                  stops: [
                                    0.0,
                                    0.5,
                                    1.0
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight)),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await updateUserData();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 10,
                                ),
                                child: const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
