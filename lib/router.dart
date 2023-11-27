import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/presentation/lock_screen/pegs/page.dart';
import 'package:app_show_categories/presentation/main_screen/bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_show_categories/injection.dart' as di;

import 'presentation/main_screen/page/home_page.dart';

class RouterGenerator {
  static bool _isInit = false;

  static Route? generateRoute(RouteSettings settings) {
    Widget? page;

    if (settings.name != null && settings.name!.startsWith(route)) {
      if (!_isInit) {
        di.init();
        _isInit = true;
      }
    } else if (_isInit) {
      di.exit();
      _isInit = false;
    }

    switch (settings.name) {
      case PasscodeLockScreenPages.ROUTE_NAME:
        final args = settings.arguments as Map?;
        page = PasscodeLockScreenPages(
          sessionStateStream: args?['sessionStateStream'],
        );
        break;
      case HomePage.ROUTE_NAME:
        final args = settings.arguments as Map?;
        page = BlocProvider(
          create: (context) => di.locator<TodoListCubit>(),
          child: HomePage(
            sessionStateStream: args?['sessionStateStream'],
          ),
        );
        break;
    }

    if (page != null) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return page!;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }
  }
}
