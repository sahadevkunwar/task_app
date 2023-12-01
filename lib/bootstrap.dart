import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_app/cubit/add_data_cubit.dart';
import 'package:task_app/cubit/delete_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/cubit/update_cubit.dart';
import 'package:task_app/source/data_source.dart';

GetIt getIt = GetIt.instance;
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerLazySingleton<DataSource>(() => DataSource());

  getIt.registerLazySingleton<FetchDataCubit>(
    () => FetchDataCubit(dataSource: getIt<DataSource>()),
  );

  getIt.registerLazySingleton<AddDataCubit>(
    () => AddDataCubit(dataSource: getIt<DataSource>()),
  );

  getIt.registerLazySingleton<DeleteCubit>(
    () => DeleteCubit(dataSource: getIt<DataSource>()),
  );
  getIt.registerLazySingleton<UpdateCubit>(
    () => UpdateCubit(dataSource: getIt<DataSource>()),
  );
}
