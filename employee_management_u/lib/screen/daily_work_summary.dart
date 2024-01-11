import 'dart:convert';
import 'package:employee_management_u/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/model/userdata.dart';

class IncompleteTaskWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> taskList;
  final VoidCallback onTasksSubmitted;

  IncompleteTaskWidget(
      {required this.taskList, required this.onTasksSubmitted});

  @override
  _IncompleteTaskWidgetState createState() => _IncompleteTaskWidgetState();
}

class _IncompleteTaskWidgetState extends State<IncompleteTaskWidget> {
  List<Map<String, dynamic>> tasks = [];
  bool isSubmitting = false;
  final dateFormatter = DateFormat('d MMMM, y');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.taskList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No tasks available.');
              } else {
                tasks = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var task in tasks)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CheckboxListTile(
                                value: task['completed'] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    task['completed'] = value;
                                  });
                                },
                                title: Text(task['task'] ?? ' '),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        // 'Date: ${task['createdAt']}'
                                        '${dateFormatter.format(DateTime.parse(task['createdAt']))}'),
                                  ],
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: const Color.fromARGB(255, 61, 124, 251),
              ),
              onPressed: isSubmitting ? null : () => submitTasks(),
              child: isSubmitting
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 61, 124, 251),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitTasks() async {
    setState(() {
      isSubmitting = true;
    });

    for (var task in tasks) {
      if (task['completed'] == true) {
        await updateTaskCompletionStatus(task['_id'], true);
      }
    }

    setState(() {
      isSubmitting = false;
    });

    // Call the callback to notify that tasks are submitted
    widget.onTasksSubmitted();
  }

  Future<void> updateTaskCompletionStatus(String taskId, bool completed) async {
    var headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'PUT',
      Uri.parse(
          'https://employee-management-u6y6.onrender.com/app/task/updateTask/$taskId'),
    );
    request.headers.addAll(headers);
    request.body = jsonEncode({
      'completed': completed,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Task $taskId completion status updated to: $completed');
      showToast("Task completed", Colors.green);
    } else {
      print('Failed to update task status. ${response.reasonPhrase}');
      showToast('Failed to update task status. ${response.reasonPhrase}',
          Colors.green);
    }
  }
}

class DailySummaryScreen extends StatefulWidget {
  const DailySummaryScreen({Key? key}) : super(key: key);

  @override
  _DailySummaryScreenState createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {
  late UserData userData;
  bool isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserProvider>(context).userInformation!;
  }

  Future<List<Map<String, dynamic>>> incompleteTasks() async {
    String getTaskUrl =
        'https://employee-management-u6y6.onrender.com/app/task/getIncompletedTaskByUserId/${userData.id}';

    try {
      final response = await http.get(Uri.parse(getTaskUrl));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Task'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IncompleteTaskWidget(
                      taskList: incompleteTasks(),
                      onTasksSubmitted: () {
                        // Reload the task list when tasks are submitted
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
