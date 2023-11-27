import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/injection.dart' as di;
import 'package:app_show_categories/presentation/main_screen/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/lock_screen/pegs/page.dart';
import 'presentation/main_screen/page/page.dart';

import 'package:flutter/material.dart';

import 'package:app_show_categories/router.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          //  const PasscodeLockScreenPages(),
          BlocProvider(
        create: (context) => di.locator<TodoListCubit>(),
        child: const HomePage(),
      ),
      onGenerateRoute: (route) => RouterGenerator.generateRoute(route),
      theme: ThemeData(fontFamily: 'DB Heavent'),
    );
  }
}
