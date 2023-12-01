part of 'selected_tasks_cubit.dart';

class CommonSelectedState {
  const CommonSelectedState({this.selectedTasks});

  final List<TaskModel>? selectedTasks;
}

class SelectedTasksState extends CommonSelectedState {
  @override
  // ignore: overridden_fields
  final List<TaskModel> selectedTasks;

  const SelectedTasksState({required this.selectedTasks})
      : super(selectedTasks: selectedTasks);

  SelectedTasksState copyWith({List<TaskModel>? selectedTasks}) {
    return SelectedTasksState(
      selectedTasks: selectedTasks ?? this.selectedTasks,
    );
  }
}
