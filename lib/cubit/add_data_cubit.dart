import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/source/data_source.dart';

class AddDataCubit extends Cubit<CommonState> {
  final DataSource dataSource;
  AddDataCubit({required this.dataSource}) : super(CommonInitialState());

  addData({required String title, required String status}) async {
    emit(CommonLoadingState());
    final res = await dataSource.addData(title: title, status: status);
    res.fold(
      (error) => emit(CommonErrorState(message: error)),
      (data) => emit(CommonSuccessState(item: null)),
    );
  }
}
