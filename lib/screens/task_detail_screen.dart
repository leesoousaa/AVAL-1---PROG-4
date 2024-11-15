import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/models/task.dart';
import '../services/task_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final service = TaskService();
  TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${task.title}'),
            Text('Descrição: ${task.description}'),
            Text('Categoria: ${task.category}'),
            Text('Vencimento: ${task.dueDate.toLocal()}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/addEditTask',
                      arguments: task,
                    );
                  },
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await service.deleteTask(task);
                    Navigator.pop(context);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
