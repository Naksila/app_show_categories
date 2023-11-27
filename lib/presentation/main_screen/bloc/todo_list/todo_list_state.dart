part of 'todo_list_cubit.dart';

sealed class TodoListState extends Equatable {
  const TodoListState();

  @override
  List<Object> get props => [];
}

final class TodoListInitial extends TodoListState {}

class TodoListFirstLoading extends TodoListState {}

class TodoListLoading extends TodoListState {}

class TodoListFailed extends TodoListState {
  final String message;
  const TodoListFailed(this.message);
}

class TodoListCancel extends TodoListState {}

class TodoListHasData extends TodoListState {
  final result;

  const TodoListHasData(
    this.result,
  );

  @override
  List<Object> get props => [];
}
