import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list_flutter/models/category.dart';
import 'package:to_do_list_flutter/models/task.dart';

class TaskService with ChangeNotifier {
  List<Task> tasks = [];
  List<Category> categories = [];
  List<DropdownMenuItem> dropdownButtons = [];
  final apiUrl = 'https://to-do-list-7e346-default-rtdb.firebaseio.com/';

  Future<void> getData() async {
    await getTasks();
    await getCategories();
    notifyListeners();
  }

  Future<void> getTasks() async {
    tasks.clear();
    final response = await http.get(Uri.parse('${apiUrl}tasks.json'));
    final data = jsonDecode(response.body);
    if (data == null || data == []) {
      tasks.clear();
    } else {
      data.forEach(
        (key, value) {
          value['id'] = key;
          tasks.add(Task.fromMap(value));
        },
      );
    }
    notifyListeners();
  }

  Future<void> getCategories() async {
    final response = await http.get(Uri.parse('${apiUrl}categories.json'));
    final data = jsonDecode(response.body);
    data.forEach(
      (key, value) {
        value['id'] = key;
        categories.add(Category.fromMap(value));
      },
    );
    for (Category category in categories) {
      dropdownButtons.add(
          DropdownMenuItem(value: category.nome, child: Text(category.nome)));
    }
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final url = Uri.parse('${apiUrl}tasks.json');
    await http.post(url, body: task.toJson());
    getTasks();
  }

  Future<void> addCategory(Category category) async {
    final url = Uri.parse('${apiUrl}categories.json');
    await http.post(url, body: category.toJson());
  }

  Future<void> updateTask(Task task) async {
    final url = Uri.parse('${apiUrl}tasks/${task.id}.json');
    await http.patch(url, body: task.toJson());
    getTasks();
  }

  Future<void> deleteTask(Task task) async {
    final url = Uri.parse('${apiUrl}tasks/${task.id}.json');
    await http.delete(url);
    getTasks();
  }
}
