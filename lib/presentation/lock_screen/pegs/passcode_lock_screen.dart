import 'dart:async';

import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/presentation/main_screen/page/page.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodeLockScreenPages extends StatefulWidget {
  static const ROUTE_NAME = '${route}/passcodelockscreenpages';

  const PasscodeLockScreenPages({super.key});

  @override
  State<PasscodeLockScreenPages> createState() =>
      _PasscodeLockScreenPagesState();
}

class _PasscodeLockScreenPagesState extends State<PasscodeLockScreenPages> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  final storedPasscode = '123456';

  _onPasscodeEntered(String enteredPasscode) {
    print('_onPasscodeEntered  >>>  ' + enteredPasscode.toString());

    bool isValid = storedPasscode == enteredPasscode;

    _verificationNotifier.add(isValid);

    if (isValid) {
      // Navigator.of(context).pushReplacementNamed(HomePage.ROUTE_NAME);
      setState(() {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushReplacementNamed(HomePage.ROUTE_NAME);
        });
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PasscodeScreen(
      title: const Text(
        'Enter App Passcode',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey, fontSize: 28, fontWeight: FontWeight.w700),
      ),
      backgroundColor: const Color.fromRGBO(155, 190, 255, 0.4),
      passwordEnteredCallback: _onPasscodeEntered,
      cancelCallback: _onPasscodeCancelled,
      keyboardUIConfig: const KeyboardUIConfig(
        digitTextStyle: TextStyle(fontSize: 60, fontWeight: FontWeight.w500),
        digitFillColor: Color.fromARGB(101, 194, 194, 194),
        primaryColor: Color.fromARGB(0, 193, 157, 157),
      ),
      circleUIConfig: const CircleUIConfig(
          fillColor: Colors.grey,
          borderColor: Color.fromARGB(193, 158, 158, 158)),
      cancelButton: const Text(''),
      deleteButton: const Text(
        'Delete',
        semanticsLabel: 'Delete',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
      ),
      shouldTriggerVerification: _verificationNotifier.stream,
    ));
  }
}
