import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/source/data_source.dart';

class DeleteCubit extends Cubit<CommonState> {
  DeleteCubit({required this.dataSource}) : super(CommonInitialState());
  final DataSource dataSource;

  deleteTask({required String id}) async {
    emit(CommonLoadingState());
    final res = await dataSource.deleteTask(id: id);
    res.fold(
      (error) => emit(CommonErrorState(message: error)),
      (data) => emit(CommonSuccessState(item: null)),
    );
  }
}
