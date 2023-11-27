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
import 'package:grouped_list/grouped_list.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '${route}/homepage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ScrollController? _scrollController;
  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();

  final _tabs = const [
    Tab(text: 'TODO'),
    Tab(text: 'DOING'),
    Tab(text: 'DONE'),
  ];

  int _offset = 0;
  int _limit = 10;
  String _status = 'TODO';
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List? _data;
  var groupByDate;

  @override
  void initState() {
    callBloc(_offset, _limit, _status);
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _scrollController!.position.extentAfter < 100) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _offset += 1;

      try {
        callBloc(_offset, _limit, _status);

        if (_data!.isEmpty) {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
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
              Positioned(
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
                  child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amberAccent,
                              child: Text('AH'),
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
                            // height: 1.5,
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
              ),
              Positioned(
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
                    children: [
                      Tabbar(
                        tabs: _tabs,
                        onTab: (p0) {
                          _data = [];
                          _offset = 0;
                          _status = _tabs[p0].text!;
                          callBloc(0, _limit, _tabs[p0].text.toString());
                        },
                        tabController: _tabController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: List<Widget>.generate(_tabs.length, (int index) {
                return BlocBuilder<TodoListCubit, TodoListState>(
                  builder: (context, state) {
                    if (state is TodoListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amberAccent,
                        ),
                      );
                    } else if (state is TodoListHasData) {
                      final tasks = state.result.tasks;

                      if (_offset != 0) {
                        _data!.addAll(tasks);
                      } else {
                        _data = tasks!;
                      }

                      return Column(
                        children: [
                          Text(
                            '${_data!.length}',
                            style: const TextStyle(fontSize: 22),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _data!.length,
                              controller: _scrollController,
                              itemBuilder: (_, index) {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            setState(() {
                                              _data!.removeAt(index);
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Color.fromARGB(76, 155, 190, 255),
                                          child: Icon(
                                            Icons.food_bank_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formatDateStringDDMMYYtoDate(
                                                    _data![index]
                                                        .createdAt
                                                        .toString()),
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 22),
                                              ),
                                              Text(
                                                _data![index].title.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromARGB(
                                                      255, 51, 51, 51),
                                                ),
                                              ),
                                              Text(
                                                _data![index]
                                                    .description
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 149, 149, 149),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.more_vert))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_isLoadMoreRunning == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.amberAccent,
                                ),
                              ),
                            ),
                          if (_hasNextPage == false) ...{}
                        ],
                      );
                    } else if (state is TodoListFailed) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      _isLoadMoreRunning = false;
                      return Container();
                    }
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

//  StickyGroupedListView<TaskEntity, DateTime>(
//               elements: _data!,
//               groupBy: (TaskEntity element) => DateTime.parse(
//                 element.createdAt.toString(),
//                 // element.createdAt!.month,
//                 // element.createdAt!.day,
//               ),
//               groupSeparatorBuilder: _getGroupSeparator,
//               itemBuilder: _getItem,
//               itemComparator: (e1, e2) =>
//                   e1.id!.compareTo(e2.id.toString()),
//               itemScrollController: itemScrollController,
//               order: StickyGroupedListOrder.ASC,
//             )

Widget _getGroupSeparator(TaskEntity element) {
  return SizedBox(
    height: 50,
    child: Align(
      alignment: Alignment.center,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.blue[300],
          border: Border.all(
            color: Colors.blue[300]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            formatDateStringDDMMYYtoDate(element.createdAt.toString()),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

Widget _getItem(BuildContext ctx, TaskEntity element) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    child: Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // setState(() {
              //   element.removeAt(index);
              // });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(76, 155, 190, 255),
            child: Icon(
              Icons.food_bank_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDateStringDDMMYYtoDate(element.createdAt.toString()),
                  style: const TextStyle(color: Colors.red, fontSize: 22),
                ),
                Text(
                  element.title.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 51, 51, 51),
                  ),
                ),
                Text(
                  element!.description.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 149, 149, 149),
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
    ),
  );
}
