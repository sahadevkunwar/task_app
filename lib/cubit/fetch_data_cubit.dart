import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/source/data_source.dart';

class FetchDataCubit extends Cubit<CommonState> {
  FetchDataCubit({required this.dataSource}) : super(CommonInitialState());
  final DataSource dataSource;

  fetchData() async {
    emit(CommonLoadingState());
    final res = await dataSource.fetchData();

    res.fold(
      (error) => emit(CommonErrorState(message: error.toString())),
      (data) => emit(CommonSuccessState<List<TaskModel>>(item: data)),
    );
  }
}
