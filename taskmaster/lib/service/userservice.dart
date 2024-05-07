import 'package:taskmaster/repository/repository.dart';

import '../model/taskdetails.dart';

class userService{
  late Repository _repository;
  userService(){
    _repository = Repository();
  }
  saveUser(Task task) async{
    return await _repository.insertData('Tasks', task.taskMap());
  }
  //read all user
  readAllUser()async{
    return await _repository.readData('Tasks');
  }
}