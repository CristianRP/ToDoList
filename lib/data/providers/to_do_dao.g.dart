// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ToDoDaoMixin on DatabaseAccessor<MyDatabase> {
  $ToDosTable get toDos => db.toDos;
  ToDo _rowToToDo(QueryRow row) {
    return ToDo(
      id: row.readInt('id'),
      title: row.readString('title'),
      content: row.readString('body'),
      dueDate: row.readDateTime('due_date'),
      image: row.readBlob('image'),
      category: row.readInt('category'),
      completed: row.readBool('completed'),
    );
  }

  Selectable<ToDo> completedToDosGeneratedQuery() {
    return customSelectQuery(
        'SELECT * FROM to_dos WHERE completed = 1 ORDER BY due_date DESC, title;',
        variables: [],
        readsFrom: {toDos}).map(_rowToToDo);
  }

  Future<List<ToDo>> completedToDosGenerated() {
    return completedToDosGeneratedQuery().get();
  }

  Stream<List<ToDo>> watchCompletedToDosGenerated() {
    return completedToDosGeneratedQuery().watch();
  }
}
