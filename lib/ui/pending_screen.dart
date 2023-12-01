import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_app/add_task.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/common/utils/confirm_delete_dialog.dart';
import 'package:task_app/common/utils/search_delegate.dart';
import 'package:task_app/common/utils/snackbar_utils.dart';
import 'package:task_app/cubit/delete_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/cubit/selected_task/selected_tasks_cubit.dart';
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
        appBar: AppBar(
          toolbarHeight: 60,
          elevation: 0, // Remove app bar shadow
          actions: [
            IconButton(
              tooltip: 'Search',
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(tasks: pendingList),
                );
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: BlocBuilder<FetchDataCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonErrorState) {
              return Center(child: Text(state.message));
            } else if (state is CommonSuccessState<List<TaskModel>>) {
              pendingList = state.item;

              if (state.item.isNotEmpty) {
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
      itemCount: pendingList.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Checkbox(
                value: completedList.contains(pendingList[index]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      completedList.add(pendingList[index]);
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          context.read<DeleteCubit>().deleteTask(
                                id: pendingList.removeAt(index).id.toString(),
                              );
                        },
                      );
                    } else {
                      pendingList.add(completedList[index]);
                      completedList.removeAt(index);
                    }

                    context
                        .read<SelectedTasksCubit>()
                        .addSelectedTask(completedList[index]);
                  });
                },
              ),
              title: Text(
                pendingList[index].title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${pendingList[index].status}',
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
                        "_id": state.item[index].id,
                        "title": state.item[index].title,
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
                      confirmDelete(context, pendingList[index].id.toString());
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
