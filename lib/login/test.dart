// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Locale _pageLocale;

  bool showPwd = true;
  bool hovering = false;
  bool _isLogin = false;
  double buttonWidth = 200;
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectOption()));
      }
    } on FirebaseAuthException catch (e) {
      errMsg = e.message;
      isError = true;
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
    } on FirebaseAuthException catch (e) {
      isError = true;
      errMsg = e.message;
    }
    setState(() {
      showIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const SizedBox(
            width: 56,
          )
        ],
        leading: IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              final newLoc = (context.locale.languageCode == 'en'
                  ? const Locale('kn')
                  : const Locale('en'));
              context.setLocale(newLoc);
            },
            icon: const Icon(Icons.language)),
        leadingWidth: 56,
        toolbarHeight: 120,
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
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
                  "login_appbar_title".tr(),
                  style: const TextStyle(
                      fontFamily: 'Ariel',
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Text(
                  "login_appbar_subtitle".tr(),
                  style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                )
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(children: [
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
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
                top: 20, bottom: 100, left: 50, right: 50),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: const Border(
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
                          fixedSize: const Size(150, 60),
                          textStyle: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          elevation: 10,
                          backgroundColor:
                              _isLogin ? Colors.green : Colors.grey[300],
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'login_button'.tr(),
                          style: TextStyle(
                              color: _isLogin ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = false),
                        style: TextButton.styleFrom(
                          fixedSize: const Size(150, 60),
                          elevation: 10,
                          textStyle: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          backgroundColor:
                              !_isLogin ? Colors.green : Colors.grey[300],
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'signup_button'.tr(),
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
                      border: const Border(
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
                                  "signup_title".tr(),
                                  style: const TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                )
                              : Text(
                                  "login_title".tr(),
                                  style: const TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
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
                                      width: 310,
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
                                                borderSide: const BorderSide(
                                                    color: Colors.yellowAccent,
                                                    width: 2)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                            icon: const Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                            labelText: "name_label".tr(),
                                            labelStyle: const TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold)),
                                        validator: (val) {
                                          if (val == null ||
                                              val.trim().isEmpty) {
                                            return 'name_error'.tr();
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
                                    width: 310,
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
                                              borderSide: const BorderSide(
                                                  color: Colors.yellowAccent,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          icon: const Icon(
                                            Icons.mail,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          labelText: "email_label".tr(),
                                          labelStyle: const TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) {
                                        if (val == null ||
                                            !val.contains('@gmail.com')) {
                                          return 'email_error'.tr();
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
                                    width: 310,
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
                                              borderSide: const BorderSide(
                                                  color: Colors.yellowAccent,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          icon: const Icon(
                                            Icons.password_sharp,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          labelText: _isLogin
                                              ? 'password_label'.tr()
                                              : 'create_password_label'.tr(),
                                          labelStyle: const TextStyle(
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'password_error'.tr();
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
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        isError
                                            ? (errMsg ?? 'generic_error'.tr())
                                            : '',
                                        style: const TextStyle(
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
                                                color: const Color.fromARGB(
                                                        255, 45, 255, 157)
                                                    .withOpacity(0.5),
                                                spreadRadius: 8,
                                                blurRadius: 16,
                                                offset: const Offset(0, 0)),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          gradient: const LinearGradient(
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
                                                ? Text(
                                                    "create_account_button"
                                                        .tr(),
                                                    style: const TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    "sign_in_button".tr(),
                                                    style: const TextStyle(
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
