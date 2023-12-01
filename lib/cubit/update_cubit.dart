import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/source/data_source.dart';

class UpdateCubit extends Cubit<CommonState> {
  UpdateCubit({required this.dataSource}) : super(CommonInitialState());
  final DataSource dataSource;

  updateTask({
    required String id,
    required String title,
    required String status
  }) async {
    emit(CommonLoadingState());
    final res = await dataSource.updateTask(id: id, title: title,status:status);
    res.fold(
      (error) => emit(CommonErrorState(message: error)),
      (data) => emit(CommonSuccessState(item: null)),
    );
  }
}
