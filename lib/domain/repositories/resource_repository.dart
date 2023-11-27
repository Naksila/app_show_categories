import 'package:app_show_categories/core/utils/failure.dart';
import 'package:app_show_categories/domain/domain.dart';
import 'package:either_dart/either.dart';

abstract class ResourceRepository {
  Future<Either<Failure, TodoListEntity>> getToDoList(
    int offset,
    int limit,
    String sortBy,
    bool isAsc,
    String status,
  );
}
