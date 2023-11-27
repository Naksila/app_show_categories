import 'dart:async';

import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/presentation/main_screen/page/page.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/src/session_timeout_manager.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodeLockScreenPages extends StatefulWidget {
  static const ROUTE_NAME = '${route}/passcodelockscreenpages';
  final StreamController<SessionState> sessionStateStream;

  PasscodeLockScreenPages({super.key, required this.sessionStateStream});

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
      widget.sessionStateStream.add(SessionState.startListening);
      setState(() {
        Future.delayed(Duration.zero, () {
          Navigator.of(context)
              .pushReplacementNamed(HomePage.ROUTE_NAME, arguments: {
            'sessionStateStream': widget.sessionStateStream,
          });
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
        'Please enter your password',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color.fromARGB(255, 51, 51, 51),
            fontSize: 28,
            fontWeight: FontWeight.w700),
      ),
      backgroundColor: const Color.fromARGB(255, 215, 234, 252),
      passwordEnteredCallback: _onPasscodeEntered,
      cancelCallback: _onPasscodeCancelled,
      keyboardUIConfig: const KeyboardUIConfig(
        digitBorderWidth: 5,
        digitTextStyle: TextStyle(fontSize: 45, fontWeight: FontWeight.w500),
        digitFillColor: Color.fromARGB(101, 194, 194, 194),
        primaryColor: Color.fromARGB(0, 193, 157, 157),
      ),
      circleUIConfig: const CircleUIConfig(
          circleSize: 16,
          fillColor: Color.fromARGB(255, 51, 51, 51),
          borderColor: Color.fromARGB(193, 158, 158, 158)),
      cancelButton: const Text(''),
      deleteButton: const Text(
        'Delete',
        semanticsLabel: 'Delete',
        style: TextStyle(
            color: Color.fromARGB(255, 51, 51, 51),
            fontWeight: FontWeight.w600),
      ),
      shouldTriggerVerification: _verificationNotifier.stream,
    ));
  }
}
