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

  late Future<List<TaskEntity>> _test;

  final _tabs = const [
    Tab(text: 'TODO'),
    Tab(text: 'DOING'),
    Tab(text: 'DONE'),
  ];

  int _offset = 0;
  int _limit = 10;
  int _totalPages = 0;
  String _status = 'TODO';
  double y = 0;

  Map<String, List<TaskEntity>>? groupByDate;
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
    super.dispose();
  }

  void loadMore() async {
    widget.sessionStateStream.add(SessionState.startListening);
    if (_scrollController!.position.extentAfter < 100) {
      callBloc(_offset + 1, _limit, _status);
    }
  }

  void callBloc(int offset, int limit, String status) {
    context.read<TodoListCubit>().getToDoList(offset, limit, status);
    widget.sessionStateStream.add(SessionState.startListening);
    setState(() {});
  }

  Future<void> _refreshData() async {
    callBloc(0, _limit, _status);

    setState(() {
      _offset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              containerHeader(context),
              containerTabbar(
                context,
                Tabbar(
                  tabs: _tabs,
                  onTab: (p0) {
                    groupByDate = null;
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

                        groupByDate = groupBy(
                            _tasks.tasks!,
                            (obj) =>
                                obj.createdAt!.toString().substring(0, 10));
                      } else if (state is TodoListFirstLoading) {
                        return const Progressbar();
                      } else if (state is TodoListEmpty) {
                      } else if (state is TodoListCancel) {}
                      return Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Text(
                            //   _tasks.tasks!.length.toString(),
                            //   style: const TextStyle(fontSize: 30),
                            // ),
                            Expanded(
                                child: RefreshIndicator(
                              color: Colors.amberAccent,
                              onRefresh: _refreshData,
                              child: Container(
                                child: Listener(
                                  onPointerMove: (details) {
                                    if (_tasks.tasks!.isNotEmpty &&
                                        details.position.dy > 800) {
                                      callBloc(_offset + 1, _limit, _status);
                                    }
                                  },
                                  child: ListView.builder(
                                    itemCount: groupByDate!.length,
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, indexOfDate) {
                                      String date = groupByDate!.keys
                                          .elementAt(indexOfDate);
                                      List<TaskEntity> itemsInCategory =
                                          groupByDate![date]!;

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 50),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16),
                                              child: Text(
                                                  formatDateStringDDMMYYtoDate(
                                                      date),
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: itemsInCategory.length,
                                              itemBuilder:
                                                  (context, _indexOfItems) {
                                                return ContainerCard(
                                                    tasks: _tasks,
                                                    id: itemsInCategory[
                                                            _indexOfItems]
                                                        .id,
                                                    title: itemsInCategory[
                                                            _indexOfItems]
                                                        .title,
                                                    description:
                                                        itemsInCategory[
                                                                _indexOfItems]
                                                            .description,
                                                    item: itemsInCategory[
                                                        _indexOfItems]);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
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

Widget containerHeader(BuildContext context) {
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

Widget containerTabbar(BuildContext context, tab) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.21,
    left: 40,
    right: 40,
    bottom: 0,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(80)),
      child: Column(
        children: [tab],
      ),
    ),
  );
}

class ContainerCard extends StatefulWidget {
  final tasks;
  final id;
  final title;
  final description;
  final item;
  const ContainerCard(
      {super.key,
      this.tasks,
      this.id,
      this.title,
      this.description,
      this.item});

  @override
  State<ContainerCard> createState() => _ContainerCardState();
}

class _ContainerCardState extends State<ContainerCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // setState(() {
              context
                  .read<TodoListCubit>()
                  .removeTask(widget.tasks, widget.item);
              // });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: CardItem(
        id: widget.id,
        title: widget.title,
        description: widget.description,
      ),
    );
  }
}
