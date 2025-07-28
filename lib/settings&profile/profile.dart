// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? selectedCountry;
  String? selectedState;
  String? photoUrl;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final FirebaseAuth authInst = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInst = FirebaseFirestore.instance;

  final List<String> countires = [
    'India',
  ];

  final List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  Future<void> updateUserData() async {
    try {
      final userUid = authInst.currentUser!.uid;
      final user = firestoreInst.collection("userInfo").doc(userUid);
      await user.update({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'dob': selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
        'country': selectedCountry,
        'state': selectedState
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Profile updated successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> getUserData() async {
    try {
      final userUid = authInst.currentUser!.uid;
      photoUrl = authInst.currentUser!.photoURL;
      final docSnapshot =
          await firestoreInst.collection("userInfo").doc(userUid).get();
      if (!docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("User document does not exist.")));
        return;
      }
      final userData = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameCtrl.text = userData['name'];
        _emailCtrl.text = userData['email'];
        _phoneCtrl.text = userData['phone'];
        final country = userData['country'] as String;
        selectedCountry = countires.contains(country) ? country : null;
        final state = userData['state'] as String;
        selectedState = states.contains(state) ? state : null;
        final ts = userData['dob'] as Timestamp?;
        selectedDate = ts?.toDate();
        if (selectedDate != null) {
          _dobCtrl.text =
              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  bool _hasPasswordProvider() {
    final user = authInst.currentUser;
    if (user == null) return false;
    return user.providerData
        .any((provider) => provider.providerId == 'password');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // Section header widget styled like the old profile page
  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Text field widget styled like the old profile page
  Widget _buildTextField(
    bool enable,
    double pad,
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: pad),
      child: TextFormField(
        enabled: enable,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: Colors.white,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // Date field widget styled like the old profile page
  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: _dobCtrl,
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null && picked != selectedDate) {
            setState(() {
              selectedDate = picked;
              _dobCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
            });
          }
        },
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon:
              const Icon(Icons.calendar_today_outlined, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // Country dropdown widget styled like the old profile page
  Widget _buildCountryField(String value, String label, List stateOrCountry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField(
        hint: Text(
          value,
          style: TextStyle(color: Colors.white70),
        ),
        dropdownColor: Colors.grey[800],
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        value: label == 'Country' ? selectedCountry : selectedState,
        items: stateOrCountry
            .map((country) => DropdownMenuItem<String>(
                  value: country,
                  child: Text(
                    country,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        onChanged: (newVal) {
          setState(() {
            if (label == 'Country') {
              selectedCountry = newVal.toString();
            } else {
              selectedState = newVal.toString();
            }
          });
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              const Icon(Icons.location_on_outlined, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Future<void> _changePassword(TextEditingController currentPwdCtrl,
      TextEditingController newPwdCtrl) async {
    if (!_hasPasswordProvider()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "You signed up with Google and don't have a password. Password changes are not available."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final curPwd = currentPwdCtrl.text.trim();
    final newPwd = newPwdCtrl.text.trim();
    final userPwdChangeInstance = authInst.currentUser;

    if (curPwd.isEmpty || newPwd.isEmpty || userPwdChangeInstance == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Fill In All The Fields!"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      await userPwdChangeInstance.updatePassword(newPwd);

      Navigator.pop(context);
      Navigator.pop(context);
      currentPwdCtrl.clear();
      newPwdCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Your Password Has Been Updated Successfully!",
          )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please Enter A Stronger Password.')));
        Navigator.pop(context);
      } else if (e.code == 'requires-recent-login') {
        try {
          final credential = EmailAuthProvider.credential(
              email: userPwdChangeInstance.email!, password: curPwd);
          await userPwdChangeInstance.reauthenticateWithCredential(credential);
          await userPwdChangeInstance.updatePassword(newPwd);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your Password Has Been Updated Successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        } on FirebaseAuthException catch (reAuthError) {
          if (reAuthError.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please Enter The Correct CURRENT passoword"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${reAuthError.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${error.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An Unexpected Error Has Occured: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showChangePwdDialog() {
    final currentPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            icon: const Icon(
              Icons.change_circle,
              size: 35,
            ),
            iconColor: Colors.black,
            title: const Text(
              "Change Password",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            content: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: currentPwdCtrl,
                    decoration: InputDecoration(
                      label: const Text('Enter Current Password'),
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(width: 2)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: newPwdCtrl,
                    decoration: InputDecoration(
                      label: const Text(
                        'Enter New Password',
                      ),
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(width: 2)),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  )),
              ElevatedButton(
                  onPressed: () {
                    _changePassword(currentPwdCtrl, newPwdCtrl);
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.green),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF0B0F33),
          Color(0xFF1C1F6B),
          Color(0xFF2C3E91),
          Color(0xFF5369D6),
        ], stops: [
          0.0,
          0.4,
          0.75,
          1.0
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Edit Profile",
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white),
          ),
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
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : const AssetImage('assets/photos/pp.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Personal Information'),
                    _buildTextField(
                        true, 20, _nameCtrl, 'Name', Icons.person_outline),
                    _buildTextField(
                        false, 20, _emailCtrl, 'Email', Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress),
                    _buildDateField(),
                    _buildTextField(
                        false, 5, _pwdCtrl, 'Password', Icons.lock_outline,
                        obscureText: true),
                    GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          showChangePwdDialog();
                        },
                        child: const Text(
                          "Change password?",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 30),
                    _buildSectionHeader('Contact Information'),
                    _buildTextField(true, 20, _phoneCtrl, 'Phone Number',
                        Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    _buildCountryField(
                        'Select your country', 'Country', countires),
                    _buildCountryField('Select your state', 'State', states),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple[300]!],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await updateUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
