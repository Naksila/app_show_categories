part of 'todo_list_cubit.dart';

sealed class TodoListState extends Equatable {
  const TodoListState();

  @override
  List<Object> get props => [];
}

final class TodoListInitial extends TodoListState {}

class TodoListFirstLoading extends TodoListState {}

class TodoListLoading extends TodoListState {
  final TodoListEntity list;
  final String? loading;
  const TodoListLoading(this.list, this.loading);
}

class TodoListFailed extends TodoListState {
  final String message;
  const TodoListFailed(this.message);
}

class TodoListCancel extends TodoListState {}

class TodoListEmpty extends TodoListState {}

class TodoListHasData extends TodoListState {
  final TodoListEntity list;

  const TodoListHasData(
    this.list,
  );
}

class TodoListFirstHasData extends TodoListState {
  final result;

  const TodoListFirstHasData(
    this.result,
  );
}
