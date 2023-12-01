import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bootstrap.dart';
import 'package:task_app/cubit/add_data_cubit.dart';
import 'package:task_app/cubit/delete_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/cubit/selected_task/selected_tasks_cubit.dart';
import 'package:task_app/cubit/update_cubit.dart';
import 'package:task_app/source/data_source.dart';
import 'package:task_app/ui/home_screen.dart';

void main() async {
  await bootstrap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FetchDataCubit(dataSource: getIt<DataSource>())..fetchData(),
        ),
        BlocProvider(
          create: (context) => AddDataCubit(dataSource: getIt<DataSource>()),
        ),
        BlocProvider(
          create: (context) => DeleteCubit(dataSource: getIt<DataSource>()),
        ),
        BlocProvider(
          create: (context) => UpdateCubit(dataSource: getIt<DataSource>()),
        ),
        BlocProvider(create: (context) => SelectedTasksCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
