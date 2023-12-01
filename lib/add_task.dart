import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:task_app/common/bloc/common_state.dart';
import 'package:task_app/common/utils/snackbar_utils.dart';
import 'package:task_app/cubit/add_data_cubit.dart';
import 'package:task_app/cubit/fetch_data_cubit.dart';
import 'package:task_app/cubit/update_cubit.dart';

class AddTask extends StatefulWidget {
  final Map? todoTask;

  const AddTask({Key? key, this.todoTask}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isEdit = false;
  String? id;

  final List<String> taskItems = ['pending', 'completed'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    final todo = widget.todoTask;
    if (todo != null) {
      isEdit = true;
      id = todo['_id'];
      final title = todo['title'];
      _titleController.text = title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: Text(isEdit ? 'Update Task' : 'Add Task'),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AddDataCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonLoadingState) {
                  setState(() {
                    _isLoading = true;
                  });
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                }
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
                    message: "Task added successfully",
                    backgroundColor: Colors.green,
                  );

                  setState(() {
                    _titleController.text = '';
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            BlocListener<UpdateCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonErrorState) {
                  showMessage(
                    context: context,
                    message: state.message,
                    backgroundColor: Colors.red,
                  );
                }
                if (state is CommonSuccessState) {
                  setState(() {
                    _titleController.text = '';
                  });
                  context.read<FetchDataCubit>().fetchData();
                  showMessage(
                    context: context,
                    message: "Task Updated Successfully",
                    backgroundColor: Colors.green,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Enter title",
                      labelText: "Title",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Value cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      //labelText: 'Status',
                      // helperText: 'hello',
                    ),
                    hint: const Text(
                      'Task Status',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: taskItems
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select task status.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Do something when selected item is changed.
                      selectedValue = value.toString();
                    },
                    onSaved: (value) {
                      selectedValue = value.toString();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[300],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          isEdit
                              ? context.read<UpdateCubit>().updateTask(
                                    id: id!,
                                    title: _titleController.text,
                                    status: selectedValue.toString(),
                                  )
                              : context.read<AddDataCubit>().addData(
                                  title: _titleController.text,
                                  status: selectedValue.toString());
                        }
                      },
                      child: Text(isEdit ? 'Update' : 'Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
