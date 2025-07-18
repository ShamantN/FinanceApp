// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<Locale, String> _localeLabels = {
    const Locale('en'): 'English',
    const Locale('kn'): 'ಕನ್ನಡ'
  };
  Locale _currentLocale = Locale('en');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = context.locale;
  }

  void _onLocaleChanged(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    context.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.green[400],
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const Text("Language(EN/KN)",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(
                width: 54,
              ),
              CupertinoSegmentedControl(
                groupValue: _currentLocale,
                onValueChanged: _onLocaleChanged,
                children: {
                  for (var entry in _localeLabels.entries)
                    entry.key: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
