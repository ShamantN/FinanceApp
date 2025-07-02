// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revesion/mainArea/selection.dart';
import 'signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPwd = true;
  bool hovering = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Image.network(
          "assets/photos/bg.jpg",
          fit: BoxFit.cover,
        )),
        Padding(
          padding: const EdgeInsets.only(
              top: 100, bottom: 100, left: 200, right: 200),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          bottomLeft: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFFF2D95).withOpacity(0.5),
                            spreadRadius: 16,
                            blurRadius: 64,
                            offset: Offset(0, 0))
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello, Create Your Account",
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
                                                color: Colors.black, width: 2)),
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
                                      if (val == null || val.trim().isEmpty) {
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
                                      Focus.of(context).requestFocus(_pwdFocus);
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
                                                color: Colors.black, width: 2)),
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
                                      await createNewUser();
                                      submitForm();
                                    },
                                    obscureText: showPwd,
                                    keyboardType: TextInputType.visiblePassword,
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
                                                color: Colors.black, width: 2)),
                                        icon: Icon(
                                          Icons.password_sharp,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                        labelText: "Create Password",
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
                                            await createNewUser();
                                            submitForm();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            elevation: 10,
                                          ),
                                          child: const Text(
                                            "Create Account",
                                            style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 10),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignIn()));
                                      },
                                      child: Text(
                                        "Sign in.",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
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
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFFF2D95).withOpacity(0.5),
                              spreadRadius: 16,
                              blurRadius: 64,
                              offset: Offset(0, 0)),
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Welcome aboard—meet your money's new best friend.",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 14,
                                color: Colors.white70),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}
