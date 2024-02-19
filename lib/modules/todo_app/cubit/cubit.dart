import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/todo_app/cubit/states.dart';
import 'package:todoapp/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  int curruntIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void changeIndex(int index) {
    curruntIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // print("database created");
        database
            .execute(
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)",
        )
            .then(
          (value) {
            // print("table created");
          },
        ).catchError((error) {
          // print("error when creating table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);

        // print("database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String? title,
    required String? time,
    required String? date,
  }) async {
    await database?.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        // print("inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        // print("error when Inserted New Record ${error.toString()}");
      });

      return Future.value(null);
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppCreateDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [
        status,
        id,
      ],
    ).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void delateData({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isbottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isbottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
