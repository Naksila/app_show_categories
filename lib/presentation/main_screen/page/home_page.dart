// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:app_show_categories/core/utils/contants.dart';
import 'package:app_show_categories/core/utils/format-date.dart';
import 'package:app_show_categories/domain/domain.dart';
import 'package:app_show_categories/presentation/lock_screen/pegs/page.dart';
import 'package:app_show_categories/presentation/main_screen/bloc/bloc.dart';
import 'package:app_show_categories/widgets/widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '${route}/homepage';
  final StreamController<SessionState> sessionStateStream;

  const HomePage({
    super.key,
    required this.sessionStateStream,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;

  final _tabs = const [
    Tab(text: 'TODO'),
    Tab(text: 'DOING'),
    Tab(text: 'DONE'),
  ];

  int _offset = 0;
  int _limit = 10;
  int _totalPages = 0;
  String _status = 'TODO';
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  Map<String, List<TaskEntity>>? _data;
  String? date;
  List<TaskEntity>? itemsInCategory;
  TodoListEntity _tasks =
      TodoListEntity(tasks: [], pageNumber: 0, totalPages: 0);

  @override
  void initState() {
    context.read<TodoListCubit>().closeState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(loadMore);
    callBloc(_offset, _limit, _status);
    super.initState();
  }

  @override
  void dispose() {
    callBloc(_offset, _limit, _status);
    _tabController?.dispose();
    _scrollController?.dispose();
    print("Disposing first route");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  void loadMore() async {
    widget.sessionStateStream.add(SessionState.startListening);
    if (_scrollController!.position.extentAfter < 100) {
      callBloc(_offset + 1, _limit, _status);
    }
  }

  void callBloc(int offset, int limit, String status) {
    context.read<TodoListCubit>().getToDoList(offset, limit, status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              _topbar(context),
              _tabbar(
                context,
                Tabbar(
                  tabs: _tabs,
                  onTab: (p0) {
                    _data = null;
                    _offset = 0;
                    _status = _tabs[p0].text!;
                    callBloc(0, _limit, _tabs[p0].text.toString());
                    widget.sessionStateStream.add(SessionState.startListening);
                  },
                  tabController: _tabController!,
                ),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: List<Widget>.generate(
                _tabs.length,
                (int index) {
                  return BlocBuilder<TodoListCubit, TodoListState>(
                    builder: (context, state) {
                      if (state is TodoListHasData) {
                        _tasks = state.list;
                        _offset = state.list.pageNumber ?? 0;

                        Map<String, List<TaskEntity>> groupByDate = groupBy(
                            _tasks.tasks!,
                            (obj) =>
                                obj.createdAt!.toString().substring(0, 10));

                        if (_offset != 0) {
                          _data?.addAll(groupByDate);
                        } else {
                          _data = groupByDate;
                        }
                      } else if (state is TodoListFirstLoading) {
                        return const Progressbar();
                      } else if (state is TodoListEmpty) {
                      } else if (state is TodoListCancel) {}
                      return Container(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            // Text(
                            //   _tasks.tasks!.length.toString(),
                            //   style: const TextStyle(fontSize: 30),
                            // ),
                            Expanded(
                                child: ListView.builder(
                              itemCount: _data!.length,
                              controller: _scrollController,
                              itemBuilder: (context, i) {
                                String date = _data!.keys.elementAt(i);
                                List<TaskEntity> itemsInCategory =
                                    _data![date]!;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: Text(
                                          formatDateStringDDMMYYtoDate(date),
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: itemsInCategory.length,
                                      itemBuilder: (context, _index) {
                                        return Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) {
                                                    widget.sessionStateStream
                                                        .add(SessionState
                                                            .startListening);

                                                    setState(() {
                                                      context
                                                          .read<TodoListCubit>()
                                                          .removeTask(
                                                              _tasks,
                                                              itemsInCategory[
                                                                  _index]);
                                                    });
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),
                                            child: CardList(
                                              title:
                                                  itemsInCategory[_index].title,
                                              description:
                                                  itemsInCategory[_index]
                                                      .description,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            )),
                            state is TodoListLoading
                                ? const Progressbar()
                                : const Center(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _topbar(BuildContext context) {
  return Positioned(
    child: Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: MediaQuery.of(context).size.height * 0.25,
      padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 215, 234, 252),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      child:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: Colors.amberAccent,
              child: Text('SN'),
            ),
          ],
        ),
        Text(
          'Hi! user',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 51, 51, 51),
          ),
        ),
        Text(
          'This is just a sample UI',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 149, 149, 149),
          ),
        ),
        Text(
          'Open to create your style :D',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            // height: 1.5,
            color: Color.fromARGB(255, 149, 149, 149),
          ),
        ),
      ]),
    ),
  );
}

Widget _tabbar(BuildContext context, tab) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.21,
    left: 40,
    right: 40,
    bottom: 0,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(70)),
      child: Column(
        children: [tab],
      ),
    ),
  );
}
