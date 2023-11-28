import 'package:app_show_categories/core/utils/exception.dart';
import 'package:app_show_categories/core/utils/failure.dart';
import 'package:app_show_categories/data/datasource/remote_data_source.dart';
import 'package:app_show_categories/domain/domain.dart';

// ignore: implementation_imports
import 'package:either_dart/src/either.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource remoteDataSourceImpl;

  ResourceRepositoryImpl(this.remoteDataSourceImpl);

  @override
  Future<Either<Failure, TodoListEntity>> getToDoList(
    int offset,
    int limit,
    String sortBy,
    bool isAsc,
    String status,
  ) async {
    try {
      var result = await remoteDataSourceImpl.getToDoList(
        offset,
        limit,
        sortBy,
        isAsc,
        status,
      );

      // print('remoteDataSourceImpl  >>> ' + result.toString());

      return Right(result.toEntity(toDoListModel: result));
    } on ServerException {
      return const Left(ServerFailure('server failure'));
    }
  }
}
