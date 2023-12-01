import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/common/utils/confirm_delete_dialog.dart';
import 'package:task_app/common/utils/snackbar_utils.dart';
import 'package:task_app/cubit/delete_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/ui/add_task.dart';
import 'package:task_app/ui/widgets/empty_task.dart';

class TaskCompletedPage extends StatefulWidget {
  const TaskCompletedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskCompletedPage> createState() => _TaskCompletedPageState();
}

class _TaskCompletedPageState extends State<TaskCompletedPage> {
  List<TaskModel> completedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DeleteCubit, CommonState>(
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
        child: BlocBuilder<FetchDataCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonErrorState) {
              return Center(child: Text(state.message));
            } else if (state is CommonSuccessState<List<TaskModel>>) {
              completedList = state.item
                  .where((task) => task.status == "Completed")
                  .toList();

              if (completedList.isNotEmpty) {
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
      itemCount: completedList.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                completedList[index].title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${completedList[index].status}',
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
                        "_id": completedList[index].id,
                        "title": completedList[index].title,
                        "status": completedList[index].status
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
                      confirmDelete(
                          context, completedList[index].id.toString());
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
