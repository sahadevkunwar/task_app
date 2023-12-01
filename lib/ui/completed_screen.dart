import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/cubit/selected_task/selected_tasks_cubit.dart';
import 'package:task_app/ui/widgets/empty_task.dart';

class TaskCompletedPage extends StatelessWidget {
  const TaskCompletedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedTasksCubit, SelectedTasksState>(
        builder: (context, state) {
          final selectedTasks = context
              .select((SelectedTasksCubit cubit) => cubit.state.selectedTasks);
          if (selectedTasks.isNotEmpty) {
            return ListView.builder(
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.purple[300]),
                          child: ListTile(
                            leading: Text("${index + 1}"),
                            title: Text(selectedTasks[index].title),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const EmptyTask();
          }
        },
      ),
    );
  }
}
