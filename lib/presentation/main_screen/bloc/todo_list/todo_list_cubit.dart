import 'dart:async';

import 'package:app_show_categories/data/data.dart';
import 'package:app_show_categories/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  Timer? _debounce;
  final TodoListUsecase _listUsecase;
  TodoListEntity data = TodoListEntity(
    tasks: [],
    pageNumber: 0,
    totalPages: 0,
  );

  TodoListCubit(this._listUsecase) : super(TodoListInitial());

  void getToDoList(offset, limit, status) async {
    bool isInitial = offset == 0;
    isInitial
        ? emit(TodoListFirstLoading())
        : emit(TodoListLoading(data, 'Loading'));

    // print('getToDoList');

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await _listUsecase.execute(
        offset,
        limit,
        'createdAt',
        true,
        status,
      );

      // print('_debounce run');
      // print('offset >> ' + offset.toString());

      response.fold(
        (left) {
          isInitial
              ? emit(TodoListFailed(left.message))
              : emit(TodoListLoading(data, 'Failed to load more data'));
          // print('left >> ' + left.message.toString());
        },
        (right) {
          print('isInitial: $isInitial');
          if (isInitial) {
            data = TodoListEntity(
              tasks: right.tasks,
              pageNumber: right.pageNumber,
              totalPages: right.totalPages,
            );
          } else {
            if (right.tasks!.isEmpty) {
              emit(TodoListEmpty());
            } else {
              data = TodoListEntity(
                tasks: [...?data.tasks, ...?right.tasks],
                pageNumber: right.pageNumber,
                totalPages: right.totalPages,
              );
            }
          }

          // print('right   >> ' + data.toString());
          // print('right length  >> ' + data.tasks!.length.toString());

          emit(TodoListHasData(data));
        },
      );
    });
  }
}
