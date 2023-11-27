import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  final tabs;
  final Function(int) onTab;
  TabController tabController;

  Tabbar({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.onTab,
  });

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: widget.tabs,
      onTap: widget.onTab,
      controller: widget.tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(
          color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
      labelStyle: const TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 14, 127, 219),
              Color.fromARGB(255, 146, 191, 227),
            ],
          )),
    );
  }
}
