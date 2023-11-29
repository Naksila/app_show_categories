import 'dart:async';

import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/injection.dart' as di;
import 'package:app_show_categories/presentation/main_screen/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import 'presentation/lock_screen/pegs/page.dart';
import 'presentation/main_screen/page/page.dart';

import 'package:flutter/material.dart';

import 'package:app_show_categories/router.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final sessionStateStream = StreamController<SessionState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  final TodoListCubit todoListCubit = TodoListCubit(di.locator());

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      // invalidateSessionForAppLostFocus: const Duration(seconds: 10),
      invalidateSessionForUserInactivity: const Duration(minutes: 10),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      print('SessionTimeoutState');
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        _navigator.push(MaterialPageRoute(
          builder: (_) => PasscodeLockScreenPages(
            sessionStateStream: sessionStateStream,
          ),
        ));
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        _navigator.push(MaterialPageRoute(
          builder: (_) => PasscodeLockScreenPages(
            sessionStateStream: sessionStateStream,
          ),
        ));
      }
    });
    return SessionTimeoutManager(
      // userActivityDebounceDuration: const Duration(seconds: 10),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        theme: ThemeData(fontFamily: 'DB Heavent'),
        onGenerateRoute: (route) => RouterGenerator.generateRoute(route),
        home:
            // BlocProvider(
            //   create: (context) => di.locator<TodoListCubit>(),
            //   child:
            //   HomePage(
            //     sessionStateStream: sessionStateStream,
            //   ),
            // )
            PasscodeLockScreenPages(
          sessionStateStream: sessionStateStream,
        ),
      ),
    );
  }
}
