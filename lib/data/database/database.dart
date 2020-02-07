import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:todo_list/data/providers/to_do_dao.dart';

part 'database.g.dart';

class ToDos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 50)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BlobColumn get image => blob().nullable()();
  IntColumn get category => integer().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();

  // Definition of custom primary keys
  // @override
  // Set<Column> get primaryKey => { id, title };
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [ToDos, Categories], daos: [ToDoDao])
class MyDatabase extends _$MyDatabase {

  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}
