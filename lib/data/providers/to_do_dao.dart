import 'package:moor/moor.dart';
import 'package:todo_list/data/database/database.dart';

part 'to_do_dao.g.dart';

@UseDao(tables: [ToDos],
queries: {
  'completedToDosGenerated' : 'SELECT * FROM to_dos WHERE completed = 1 ORDER BY due_date DESC, title;'
})
class ToDoDao extends DatabaseAccessor<MyDatabase> with _$ToDoDaoMixin {
  final MyDatabase db;

  ToDoDao(this.db) : super(db);

  Future<List<ToDo>> get allToDoEntries => select(toDos).get();

  Stream<List<ToDo>> watchAllToDoEntries() => select(toDos).watch();

  Stream<List<ToDo>> watchEntriesInCategory(Category c) {
    return (select(toDos)..where((t) => t.category.equals(c.id))).watch();
  }

  Future<int> addToDoEntry(Insertable<ToDo> entry) {
    return into(toDos).insert(entry);
  }

  Future<bool> updateToDoEntry(Insertable<ToDo> entry) {
    return update(toDos).replace(entry);
  }

  Future<int> deleteToDo(Insertable<ToDo> entry) {
    return delete(toDos).delete(entry);
  }

  Future<void> insertMultipleEntries() async {
    await batch((batch) {
      batch.insertAll(toDos, [ToDosCompanion.insert(title: null, content: null)]);
    });
  }

  SimpleSelectStatement<ToDos, ToDo> orderByDueDateAndTitle() {
    return (select(toDos)
      ..orderBy(
        ([
          (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.title)
        ])
      ));
  }

  Stream<List<ToDo>> watchAllTaskOrdered() {
    return (
        orderByDueDateAndTitle()
      ).watch();
  }


  Stream<List<ToDo>> watchCompletedTask() {
    return (
      orderByDueDateAndTitle()
      ..where((t) => t.completed.equals(true)))
      .watch();
  }

  Selectable<ToDo> completedToDoCustom() {
    return customSelectQuery(
      'SELECT * FROM to_dos WHERE completed = 1 ORDER BY due_date DESC, title;',
      readsFrom: { toDos },
    )
    .map((row) => ToDo.fromData(row.data, db));
  }

  Stream<List<ToDo>> watchCompletedTaskCustom() {
    return completedToDoCustom().watch();
  }
}