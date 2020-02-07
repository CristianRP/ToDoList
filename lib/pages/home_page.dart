import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/database/database.dart';
import 'package:todo_list/data/providers/to_do_dao.dart';
import 'package:todo_list/widgets/new_todo_input_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: <Widget>[_buildShowCompletedOnlySwitch()],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildToDoList(context)),
          NewTodoInput()
        ],
      ),
    );
  }

  Row _buildShowCompletedOnlySwitch() {
    return Row(
      children: <Widget>[
        Text('Completed only'),
        Switch(
          value: showCompleted,
          activeColor: Colors.white,
          onChanged: (newValue) {
            setState(() {
              showCompleted = newValue;
            });
          },
        )
      ],
    );
  }

  StreamBuilder<List<ToDo>> _buildToDoList(BuildContext context) {
    final dao = Provider.of<ToDoDao>(context);
    return StreamBuilder(
      stream: showCompleted ? dao.watchCompletedTask() : dao.watchAllToDoEntries(),
      builder: (context, AsyncSnapshot<List<ToDo>> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final toDos = snapshot.data ?? List();

        if (toDos.length == 0)
          return Center(child: Text('List of To-Dos is empty'));

        return ListView.builder(
          itemCount: toDos.length,
          itemBuilder: (_, index) {
            final itemToDo = toDos[index];
            return _buildListItem(itemToDo, dao);
          }
        );
      },
    );
  }

  Slidable _buildListItem(ToDo toDo, ToDoDao dao) {
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.deleteToDo(toDo)
        )
      ],
      child: Container(
        color: Colors.white,
        child: CheckboxListTile(
          title: Text(toDo.title),
          subtitle: Text(toDo.dueDate?.toString() ?? 'No due date'),
          value: toDo.completed,
          secondary: Text('${toDo.id}', style: TextStyle(color: Colors.grey, fontSize: 30.0)),
          onChanged: (newValue) {
            dao.updateToDoEntry(toDo.copyWith(completed: newValue));
          },
        ),
      ),
    );
  }

}
