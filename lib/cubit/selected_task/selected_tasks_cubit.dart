// selected_tasks_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/model/task.dart';

part 'selected_tasks_state.dart';

class SelectedTasksCubit extends Cubit<SelectedTasksState> {
  SelectedTasksCubit() : super(const SelectedTasksState(selectedTasks: []));

  void addSelectedTask(TaskModel task) {
    emit(state.copyWith(
      selectedTasks: List.from(state.selectedTasks)..add(task),
    ));
  }

  void clearSelectedTasks() {
    emit(state.copyWith(selectedTasks: []));
  }
}
