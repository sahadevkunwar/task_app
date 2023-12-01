import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
      child: Scaffold(
        appBar: AppBar(
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
        floatingActionButton: FloatingActionButton(
          //elevation: 1,
          backgroundColor: Colors.grey.shade300,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: const AddTask(),
              ),
            );
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
