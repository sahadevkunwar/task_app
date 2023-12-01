import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_app/common/utils/search_delegate.dart';
import 'package:task_app/cubit/selected_task/selected_tasks_cubit.dart';
import 'package:task_app/ui/pending_screen.dart';
import 'package:task_app/ui/completed_screen.dart';
import 'add_task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: BlocBuilder<SelectedTasksCubit, SelectedTasksState>(
        builder: (context, state) {
          final selectedTasks = context
              .select((SelectedTasksCubit cubit) => cubit.state.selectedTasks);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  tooltip: 'Search',
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DataSearch(tasks: selectedTasks),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                    tooltip: 'Add task',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: const AddTask(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 35))
              ],
              //elevation: 3,
              backgroundColor: Colors.grey.shade200,
              title: const Text('Task Management App'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Pending Task'),
                  Tab(text: 'Completed Task'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                TaskPendingPage(),
                TaskCompletedPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}
