import 'dart:convert';

import 'package:app_show_categories/core/utils/exception.dart';
import 'package:app_show_categories/data/data.dart';
import 'package:dio/dio.dart';

abstract class ResourceRemoteDataSource {
  Future<ToDoListModel> getToDoList(
    int offset,
    int limit,
    String sortBy,
    bool isAsc,
    String status,
  );
}

class ResourceRemoteDataSourceImpl extends ResourceRemoteDataSource {
  @override
  Future<ToDoListModel> getToDoList(
    int offset,
    int limit,
    String sortBy,
    bool isAsc,
    String status,
  ) async {
    try {
      var dio = Dio();
      var response = await dio
          .request('https://todo-list-api-mfchjooefq-as.a.run.app/todo-list',
              options: Options(
                method: 'GET',
              ),
              queryParameters: {
            'offset': offset,
            'limit': limit,
            'sortBy': sortBy,
            'isAsc': isAsc,
            'status': status,
          });

      if (response.statusCode != 200) {
        throw ServerException(response.statusMessage.toString());
      }

      print('json  >>> ' + json.encode(response.data));

      return ToDoListModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
