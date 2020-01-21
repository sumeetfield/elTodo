import 'package:sidedrawer/models/todo.dart';
import 'package:sidedrawer/repositories/repository.dart';

class TodoService{

  Repository _repository;

  TodoService(){
    _repository = Repository();
  }

  saveTodo(Todo todo) async {
    return await _repository.save('todos', todo.todoMap());
  }
}