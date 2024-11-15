import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/models/task.dart';
import 'package:to_do_list_flutter/services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = TaskService();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final future = service.getData();
    future.then(
      (value) {
        setState(() {
          categoryController.text = 'Selecione uma categoria';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de tarefas'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: service.tasks.length,
                itemBuilder: (context, index) {
                  Task task = service.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        task.isCompleted = value!;
                        setState(() {
                          service.updateTask(task);
                        });
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              titleController.text = task.title;
                              descriptionController.text = task.description;
                              categoryController.text = task.category;
                              dateController.text = task.dueDate.toString();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            titleController.clear();
                                            descriptionController.clear();
                                            dateController.clear();
                                            categoryController.text =
                                                'Selecione uma categoria';
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Fechar')),
                                      TextButton(
                                          onPressed: () {
                                            Task updatedTask = Task(
                                                isCompleted: task.isCompleted,
                                                id: task.id,
                                                title: titleController.text,
                                                description:
                                                    descriptionController.text,
                                                dueDate: DateTime.parse(
                                                    dateController.text),
                                                category:
                                                    categoryController.text);
                                            service.updateTask(updatedTask);
                                            Navigator.of(context).pop();
                                            titleController.clear();
                                            descriptionController.clear();
                                            dateController.clear();
                                            categoryController.text =
                                                'Selecione uma categoria';
                                          },
                                          child: const Text('Atualizar')),
                                    ],
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(
                                            labelText: 'Título',
                                          ),
                                        ),
                                        TextField(
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                            labelText: 'Descrição',
                                          ),
                                        ),
                                        DropdownButton(
                                            value: categoryController.text,
                                            items: service.dropdownButtons,
                                            onChanged: (value) {
                                              categoryController.text = value!;
                                            }),
                                        TextField(
                                          controller: dateController,
                                          decoration: const InputDecoration(
                                            labelText: 'Selecione a data',
                                            filled: false,
                                            prefixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2060),
                                            );

                                            if (picked != null) {
                                              setState(() {
                                                dateController.text =
                                                    picked.toString();
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.edit)),
                        ElevatedButton(
                            onPressed: () {
                              service.deleteTask(task);
                            },
                            child: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tarefa'),
                  content: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                        ),
                        DropdownButton(
                            value: categoryController.text,
                            items: service.dropdownButtons,
                            onChanged: (value) {
                              categoryController.text = value!;
                            }),
                        TextField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            labelText: 'Selecione a data',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2050),
                            );

                            if (picked != null) {
                              setState(() {
                                dateController.text = picked.toString();
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                        onPressed: () {
                          titleController.clear();
                          descriptionController.clear();
                          dateController.clear();
                          categoryController.text = 'Selecione uma categoria';
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fechar')),
                    TextButton(
                        onPressed: () {
                          Task task = Task(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              description: descriptionController.text,
                              dueDate: DateTime.parse(dateController.text),
                              category: categoryController.text);
                          service.addTask(task);
                          Navigator.of(context).pop();
                          titleController.clear();
                          descriptionController.clear();
                          dateController.clear();
                          categoryController.text = 'Selecione uma categoria';
                        },
                        child: const Text('Salvar')),
                  ],
                ),
              );
            },
            child: const Icon(Icons.add_circle_outline),
          ),
        );
      },
    );
  }
}
