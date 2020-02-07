import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/home_page.dart';

import 'data/database/database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => MyDatabase().toDoDao, // (_) it's a BuildContext type
      child: MaterialApp(
        title: 'Material App',
        home: HomePage()
      ),
    );
  }
}