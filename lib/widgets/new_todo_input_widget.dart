import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/database/database.dart';

class NewTodoInput extends StatefulWidget {
  NewTodoInput({Key key}) : super(key: key);

  @override
  _NewTodoInputState createState() => _NewTodoInputState();
}

class _NewTodoInputState extends State<NewTodoInput> {

  DateTime newToDoDate;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context)
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'New To Do action'),
        textInputAction: TextInputAction.next,
        onSubmitted: (inputName) {
          //print(inputName);
          final database = Provider.of<MyDatabase>(context, listen: false);
          final toDo = ToDo(
            title: inputName,
            dueDate: newToDoDate,
            content: inputName
          );
          database.addToDoEntry(toDo);
          resetValuesAfterSubmit();
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newToDoDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2010), lastDate: DateTime(2050));
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newToDoDate = null;
      controller.clear();
    });
  }
}