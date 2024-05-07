class Task{
   int? id;
  late String title;
  late String description;
  late DateTime dateTime;
  late String priority;
  taskMap(){
    var taskmap = Map<String,dynamic>();
    taskmap['id']=id;
    taskmap['title']=title;
    taskmap['description']=description;
    taskmap['dateTime']=  dateTime.toIso8601String();
    taskmap['priority']=priority;
    return taskmap;
  }
}