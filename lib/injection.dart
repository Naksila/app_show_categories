import 'package:app_show_categories/data/repositories/resource_repository_impl.dart';
import 'package:app_show_categories/presentation/main_screen/bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/data.dart';
import 'domain/domain.dart';

final locator = GetIt.instance;

void init() {
  // DataSource
  if (!locator.isRegistered<ResourceRemoteDataSource>()) {
    locator.registerLazySingleton<ResourceRemoteDataSource>(
        () => ResourceRemoteDataSourceImpl());
  }

  // Repository
  if (!locator.isRegistered<ResourceRepository>()) {
    locator.registerLazySingleton<ResourceRepository>(
        () => ResourceRepositoryImpl(locator()));
  }

  // Usecase
  if (!locator.isRegistered<TodoListUsecase>()) {
    locator.registerLazySingleton(() => TodoListUsecase(
          repository: locator(),
        ));
  }

  // bloc
  if (!locator.isRegistered<TodoListCubit>()) {
    locator.registerLazySingleton(() => TodoListCubit(locator()));
  }
}

void exit() {}
