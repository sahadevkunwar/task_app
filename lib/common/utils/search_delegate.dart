import 'package:flutter/material.dart';
import 'package:task_app/model/task.dart';

class DataSearch extends SearchDelegate<String> {
  final List<TaskModel> tasks;

  DataSearch(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.tasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    //Action for appbar
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
//Icon leading
    return IconButton(
      onPressed: () {
        close(context, '');
        //  Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement the logic to display search results
    // based on the query and the tasks list.

    final results = tasks.where((task) => task.title.contains(query)).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          // Add onTap logic for handling selection.
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement the logic to display suggestions
    // based on the query and the tasks list.
    // Example:
    final suggestions = tasks
        .where(
            (task) => task.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          // Add onTap logic for handling selection.
        );
      },
    );
  }
}
