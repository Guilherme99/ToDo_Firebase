import 'package:firebase_todo/app/modules/home/home_controller.dart';
import 'package:firebase_todo/app/modules/home/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Observer(
        builder: (_) {
          var data = controller.todoList!;
          if (data.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: controller.getList(),
                child: Text("Recarregar"),
              ),
            );
          }

          if (data.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TodoModel> list = data.data;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              TodoModel model = list[index];
              return ListTile(
                title: Text(model.title.toString()),
                onTap: () => _showDialog(model),
                leading: IconButton(
                  icon: Icon(Icons.remove_circle_outline_rounded),
                  onPressed: model.delete,
                ),
                trailing: Checkbox(
                    value: model.check,
                    onChanged: (check) {
                      model.check = check!;
                      model.save();
                    }),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog([TodoModel? model]) {
    model ??= TodoModel();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(model!.title.isEmpty ? "Novo ToDo" : "Edição"),
            content: TextFormField(
              initialValue: model.title,
              onChanged: (value) => model!.title = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nome",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                  onPressed: () async {
                    await model!.save();
                    Modular.to.pop();
                  },
                  child: Text("Salvar"))
            ],
          );
        });
  }
}
