import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmaster/model/taskdetails.dart';
import 'package:taskmaster/repository/repository.dart';
import 'package:taskmaster/service/userservice.dart';
import 'package:taskmaster/utils/routes.dart';

class EditTask extends StatefulWidget {
  Task task;
  EditTask({required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime? _selectedDate;
  String selectedOption = 'Low';
  TextEditingController _title= TextEditingController();
  final TextEditingController _desc= TextEditingController();
  final _formkey= GlobalKey<FormState>();
  var _userService = userService();
  var _repository = Repository();
  @override
  void initState() {
    // TODO: implement initState
    _title.text=widget.task.title;
    _desc.text=widget.task.description;
    selectedOption=widget.task.priority;
    _selectedDate=widget.task.dateTime;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 0.04.sw, right: 0.04.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.01.sh,
                ),
                Text(
                  "Title",
                  style: TextStyle(
                      fontFamily: GoogleFonts.alata().fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: TextFormField(
                    controller: _title,
                    maxLength: 50,
                    style: TextStyle(letterSpacing: 2, fontSize: 18),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if(value!.isEmpty) return "Title should not be empty";
                      else if(value.length<=3) return "should be greater then 3 letters";
                      return null;
                    },
                  ),
                ),
                SizedBox(),
                Text(
                  "Description",
                  style: TextStyle(
                      fontFamily: GoogleFonts.alata().fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                SizedBox(
                    width: double.maxFinite,
                    child: TextFormField(
                      maxLength: 100,
                      controller: _desc,
                      style: TextStyle(letterSpacing: 2, fontSize: 18),
                      maxLines: 4,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(10))),
                    )),
                SizedBox(
                  height: 0.04.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 0.4.sw,
                      height: 0.04.sh,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue),
                      child: TextButton(
                        onPressed: () {
                          _selectDateTime(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          '${_selectedDate != null ? '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year} ${_selectedDate?.hour}:${_selectedDate?.minute}' : "Select the date and time"}',
                          style: TextStyle(
                              fontSize: _selectedDate != null ? 14.0.sp : 11.0.sp,
                              fontWeight: FontWeight.bold,fontFamily: GoogleFonts.alata().fontFamily,color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Container(
                        width: 0.37.sw,
                        height: 0.04.sh,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          dropdownColor: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                            size: 20.0.sp,
                          ),
                          underline: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0XFFff9f00),
                                  Color(0XFFff7f00)
                                ],
                              ),
                            ),
                          ),
                          value: selectedOption,
                          items: <String>["Low", "High", "Very high"]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                              value: value,
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,fontSize: 15,fontFamily: GoogleFonts.alata().fontFamily,color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedOption=value!;
                            });
                          },
                        )),
                  ],
                ),
                SizedBox(height: 0.04.sh,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 0.37.sw,
                      height: 0.05.sh,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow),
                      child: TextButton(
                        child: Text("Update",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,fontFamily: GoogleFonts.alata().fontFamily),),
                        onPressed: () async {
                          _formkey.currentState!.validate();
                          if(_formkey.currentState!.validate()){
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(color: Colors.black,),
                                );
                              },
                            );
                            saveDataToDatabase().then((_) {
                              Navigator.pushReplacementNamed(context, MyRoutes.homepage);
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
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

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine pickedDate and pickedTime into a single DateTime
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDateTime;
        });
      }
    }
  }
  Future<void> saveDataToDatabase() async {
    var _task = Task();
    _task.id=widget.task.id;
    _task.title=_title.text;
    _task.description=_desc.text.isNotEmpty?_desc.text:"no description found";
    _task.priority=selectedOption;
    _task.dateTime=_selectedDate==null?DateTime.now():_selectedDate!;
    var result =await _repository.updateData('Tasks', _task.taskMap()) ;
  }
}
