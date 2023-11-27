import 'package:app_show_categories/core/utils/failure.dart';
import 'package:app_show_categories/domain/domain.dart';
import 'package:either_dart/either.dart';

class TodoListUsecase {
  final ResourceRepository repository;

  TodoListUsecase({required this.repository});

  Future<Either<Failure, TodoListEntity>> execute(
    int offset,
    int limit,
    String sortBy,
    bool isAsc,
    String status,
  ) {
    return repository.getToDoList(
      offset,
      limit,
      sortBy,
      isAsc,
      status,
    );
  }
}
