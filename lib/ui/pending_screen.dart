import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_app/cubit/selected_task/selected_tasks_cubit.dart';
import 'package:task_app/ui/add_task.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/common/utils/confirm_delete_dialog.dart';
import 'package:task_app/common/utils/snackbar_utils.dart';
import 'package:task_app/cubit/delete_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/ui/widgets/empty_task.dart';

class TaskPendingPage extends StatefulWidget {
  const TaskPendingPage({Key? key}) : super(key: key);

  @override
  State<TaskPendingPage> createState() => _TaskPendingPageState();
}

class _TaskPendingPageState extends State<TaskPendingPage> {
  List<TaskModel> pendingList = [];
  List<TaskModel> completedList = [];
  List<TaskModel> currentTasks = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonErrorState) {
          showMessage(
            context: context,
            message: state.message,
            backgroundColor: Colors.red,
          );
        }
        if (state is CommonSuccessState) {
          context.read<FetchDataCubit>().fetchData();
          showMessage(
            context: context,
            message: "Task deleted successfully",
            backgroundColor: Colors.green,
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<FetchDataCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonErrorState) {
              return Center(child: Text(state.message));
            } else if (state is CommonSuccessState<List<TaskModel>>) {
              // Filter the list to include only items with status "pending"
              currentTasks =
                  state.item.where((task) => task.status == "Pending").toList();

              if (currentTasks.isNotEmpty) {
                return pendingScreenItems(state);
              } else {
                return const EmptyTask();
              }
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView pendingScreenItems(CommonSuccessState<List<TaskModel>> state) {
    return ListView.builder(
      itemCount: currentTasks.length,
      itemBuilder: (context, index) {
        ///for passing total list to search screen
        List<TaskModel> tempList = state.item;
        context.read<SelectedTasksCubit>().addSelectedTask(tempList[index]);

        ///end here
        return SingleChildScrollView(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                currentTasks[index].title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${currentTasks[index].status}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 24,
                    tooltip: 'Edit',
                    onPressed: () {
                      final Map<String, dynamic> item = {
                        "_id": currentTasks[index].id,
                        "title": currentTasks[index].title,
                        "status": currentTasks[index].status
                      };

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: AddTask(
                            todoTask: item,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    iconSize: 24,
                    tooltip: 'Delete',
                    onPressed: () {
                      confirmDelete(context, currentTasks[index].id.toString());
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
