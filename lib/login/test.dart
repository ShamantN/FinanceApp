// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPwd = true;
  bool hovering = false;
  bool _isLogin = false;
  double buttonWidth = 250;
  double buttonPad = 5;
  String? errMsg = '';
  bool showIndicator = false;
  bool isError = false;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _pwdFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  void submitForm() {
    final form = _formKey.currentState!;

    if (!form.validate()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pwd = _pwdCtrl.text.trim();

    form.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _pwdCtrl.clear();
  }

  Future<void> createNewUser() async {
    setState(() {
      showIndicator = true;
    });
    String userName = _nameCtrl.text.trim();
    String userEmail = _emailCtrl.text.trim();
    String userPwd = _pwdCtrl.text.trim();
    try {
      final userCreds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: userPwd);

      if (FirebaseAuth.instance.currentUser != null) {
        await uploadToFirestore(userCreds, userName, userEmail);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelectOption()));
      }
      print(userCreds);
    } on FirebaseAuthException catch (e) {
      // e is of type firebaseauthexception
      errMsg = e.message;
      isError = true;
      print(errMsg);
    }
    setState(() {
      showIndicator = false;
    });
  }

  Future<void> uploadToFirestore(
      UserCredential userCreds, String userName, String userEmail) async {
    try {
      final currentUserUid = userCreds.user!.uid;
      final users = FirebaseFirestore.instance.collection("userInfo");
      await users.doc(currentUserUid).set({
        'name': userName,
        'email': userEmail,
        'phone': '',
        'dob': null,
        'country': '',
        'createdAt': FieldValue.serverTimestamp()
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> loginUser() async {
    setState(() {
      showIndicator = true;
    });
    String userEmail = _emailCtrl.text.trim();
    String userPwd = _pwdCtrl.text.trim();

    try {
      final userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPwd);
      print(userCreds);
    } on FirebaseAuthException catch (e) {
      isError = true;
      errMsg = e.message;
      print(e.message);
    }
    setState(() {
      showIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/photos/pf_logo.png',
              height: 100,
              width: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "PUTTAINNAIH",
                  style: TextStyle(
                      fontFamily: 'Ariel',
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                ),
                Text(
                  "FOUNDATION",
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                )
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 236, 255, 213),
                      Color(0xFFB8F2A8),
                      Color.fromARGB(255, 100, 209, 103),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.5, 1.0])),
          )),
          Padding(
            padding: const EdgeInsets.only(
                top: 80, bottom: 100, left: 650, right: 650),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 2),
                          bottom: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.black, width: 2))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isLogin = true),
                        style: TextButton.styleFrom(
                          fixedSize: Size(150, 60),
                          textStyle: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          elevation: 10,
                          backgroundColor:
                              _isLogin ? Colors.green : Colors.grey[300],
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: _isLogin ? Colors.white : Colors.black),
                        ),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = false),
                        style: TextButton.styleFrom(
                          fixedSize: Size(150, 60),
                          elevation: 10,
                          textStyle: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          backgroundColor:
                              !_isLogin ? Colors.green : Colors.grey[300],
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: !_isLogin ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(32),
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 2),
                          bottom: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !_isLogin
                              ? Text(
                                  "Hello, Create Your Account",
                                  style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                                )
                              : Text(
                                  "Hello, Sign In To Your Account",
                                  style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                                ),
                          const SizedBox(
                            height: 40,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!_isLogin)
                                  Center(
                                    child: SizedBox(
                                      width: 500,
                                      child: TextFormField(
                                        focusNode: _nameFocus,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          Focus.of(context)
                                              .requestFocus(_emailFocus);
                                        },
                                        autofocus: false,
                                        autocorrect: false,
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        controller: _nameCtrl,
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                borderSide: BorderSide(
                                                    color: Colors.yellowAccent,
                                                    width: 2)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                            icon: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.black,
                                            ),
                                            labelText: "Name",
                                            labelStyle: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold)),
                                        validator: (val) {
                                          if (val == null ||
                                              val.trim().isEmpty) {
                                            return 'Please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 500,
                                    child: TextFormField(
                                      focusNode: _emailFocus,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        Focus.of(context)
                                            .requestFocus(_pwdFocus);
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: false,
                                      autocorrect: false,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      controller: _emailCtrl,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: BorderSide(
                                                  color: Colors.yellowAccent,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          icon: Icon(
                                            Icons.mail,
                                            size: 40,
                                            color: Colors.black,
                                          ),
                                          labelText: "E-Mail Address",
                                          labelStyle: TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) {
                                        if (val == null ||
                                            !val.contains('@gmail.com')) {
                                          return 'Please enter a valid E-Mail address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 500,
                                    child: TextFormField(
                                      focusNode: _pwdFocus,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) async {
                                        if (_isLogin) {
                                          await loginUser();
                                        } else {
                                          await createNewUser();
                                        }
                                        submitForm();
                                      },
                                      obscureText: showPwd,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofocus: false,
                                      autocorrect: false,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      controller: _pwdCtrl,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showPwd = !showPwd;
                                                });
                                              },
                                              icon: Icon(showPwd
                                                  ? Icons.visibility_off
                                                  : Icons.visibility)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: BorderSide(
                                                  color: Colors.yellowAccent,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          icon: Icon(
                                            Icons.password_sharp,
                                            size: 40,
                                            color: Colors.black,
                                          ),
                                          labelText: _isLogin
                                              ? 'Password'
                                              : 'Create Password',
                                          labelStyle: TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                showIndicator
                                    ? CircularProgressIndicator()
                                    : Text(
                                        isError
                                            ? (errMsg ?? 'An error has occured')
                                            : '',
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontStyle: FontStyle.italic,
                                            color: Colors.red),
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: buttonWidth,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 45, 255, 157)
                                                    .withOpacity(0.5),
                                                spreadRadius: 8,
                                                blurRadius: 16,
                                                offset: Offset(0, 0)),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(32),
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
                                        padding: EdgeInsets.all(buttonPad),
                                        child: ElevatedButton(
                                            onHover: (hover) {
                                              if (hover) {
                                                setState(() {
                                                  buttonWidth = 300;
                                                  buttonPad = 8;
                                                });
                                              } else {
                                                setState(() {
                                                  buttonWidth = 250;
                                                  buttonPad = 5;
                                                });
                                              }
                                            },
                                            onPressed: () async {
                                              if (_isLogin) {
                                                await loginUser();
                                              } else {
                                                await createNewUser();
                                              }
                                              submitForm();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: Colors.white,
                                              elevation: 10,
                                            ),
                                            child: !_isLogin
                                                ? const Text(
                                                    "Create Account",
                                                    style: TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const Text(
                                                    "Sign In",
                                                    style: TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
