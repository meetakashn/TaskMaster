import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmaster/edit%20task/edittask.dart';
import 'package:taskmaster/model/taskdetails.dart';
import 'package:taskmaster/repository/repository.dart';
import 'package:taskmaster/service/userservice.dart';
import 'package:taskmaster/utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Task> _taskList = <Task>[];
  final _userService = userService();
  Repository _repository = Repository();

  @override
  void initState() {
    // TODO: implement initState
    getAllUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.black87,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            "Task Master",
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.adventPro().fontFamily),
          ),
          leading: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        body: _taskList.isEmpty
            ? Center(
                child: Text(
                  "No Task Found",
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  Task task = _taskList[index];
                  return Card(
                    color: Colors.black87,
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${task.description} ${task.dateTime}",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.star,
                        color: task.priority == "Low"
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTask(task: task),
                                  ));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Are you sure you want to delete this task? This action cannot be undone"),
                                      alignment: Alignment.center,
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              _repository.deleteDataById(
                                                  'Tasks', task.id);
                                              _taskList.clear();
                                              getAllUserDetails();
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.addtask);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }

  getAllUserDetails() async {
    var users = await _userService.readAllUser();
    users.forEach((task) {
      setState(() {
        var taskModel = Task();
        taskModel.id = task['id'];
        taskModel.title = task['title'];
        taskModel.description = task['description'];
        String dateTimeString = task['dateTime'];
        String trimmedDateTimeString = dateTimeString.substring(
            0, 16); // Exclude seconds and milliseconds (up to index 16)
        DateTime parsedDateTime = DateTime.parse(
            trimmedDateTimeString); // Parse and format the date string
        taskModel.dateTime = parsedDateTime;
        taskModel.priority = task['priority'];
        _taskList.add(taskModel);
      });
    });
    // Sorting by priority (high to low) and then by date
    _taskList.sort((a, b) {
      // First, sort by priority (high to low)
      int priorityComparison =
          _priorityToValue(b.priority).compareTo(_priorityToValue(a.priority));
      if (priorityComparison != 0) {
        return priorityComparison;
      }
      // If priorities are the same, sort by date
      return a.dateTime.compareTo(b.dateTime);
    });
  }

  int _priorityToValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return 0;
      case 'very high':
        return 1;
      case 'high':
        return 2;
      default:
        return 0; // Assign lowest priority to unknown values
    }
  }

  Future<void> _refreshData() async {
    _taskList.clear();
    await getAllUserDetails();
  }
}
