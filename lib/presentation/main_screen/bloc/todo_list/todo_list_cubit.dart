import 'package:app_show_categories/data/data.dart';
import 'package:app_show_categories/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  final TodoListUsecase _listUsecase;

  TodoListCubit(this._listUsecase) : super(TodoListInitial());

  void getToDoList(offset, limit, status) async {
    emit(TodoListLoading());

    final response = await _listUsecase.execute(
      offset,
      limit,
      'createdAt',
      false,
      status,
    );

    print('status >> ' + status);

    response.fold(
      (left) {
        print('left >> ' + left.message.toString());
        emit(TodoListFailed(left.message));
      },
      (right) {
        print('right  >> ' + right.toString());
        print('length >> ' + right.tasks!.length.toString());

        emit(TodoListHasData(right));
      },
    );
  }
}
