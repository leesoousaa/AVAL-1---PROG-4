import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/models/task.dart';
import '../services/task_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _category = 'Trabalho';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _category = widget.task!.category;
    }
  }

  void _saveTask() async {
    Task task = Task(
      id: widget.task?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      category: _category,
    );

    if (widget.task == null) {
      await TaskService().addTask(task);
    } else {
      await TaskService().updateTask(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título')),
            TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição')),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != _dueDate) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
              child: const Text('Escolher Data de Vencimento'),
            ),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
