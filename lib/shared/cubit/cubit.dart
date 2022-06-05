import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/modules/archived_tasks/ArchivedTaskScreen.dart';
import 'package:todo_app/modules/done_tasks/DoneTaskScreen.dart';
import 'package:todo_app/modules/new_tasks/NewTaskScreen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit getObject(BuildContext context) => BlocProvider.of(context);

  /// BottomNavigationBar Logic
  List<String> titles = ["New", "Done", "Archived"];
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  ///----------------------------------------------------

  /// Database Logic
  Database? myDb;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Future<void> createDatabase() async {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('Database created');
        db
            .execute(
                'create table tasks(id integer primary key,title text,date text,time text,status text)')
            .then((value) => print('Table created'))
            .catchError((error) => print(error.toString()));
      },
      onOpen: (db) async {
        getDataFromDatabase(db);
      },
    ).then((value) {
      myDb = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    myDb!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) values ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

        // After insert a new raw in tasks table we getDataFromDatabase
        getDataFromDatabase(myDb!);
      }).catchError((e) {
        print('Error when inserted new record ${e.toString()}');
      });
    });
  }

  void getDataFromDatabase(Database db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    db.rawQuery('select * from tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) {
    myDb!.rawUpdate('UPDATE tasks SET status= ? WHERE id= ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(myDb!);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({required int id}) {
    myDb!.rawDelete('DELETE FROM tasks WHERE id= ?', [id]).then((value) {
      getDataFromDatabase(myDb!);
      emit(AppDeleteDatabaseState());
    });
  }

  ///---------------------------------------------------------------

  /// BottomSheet Logic
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  ///---------------------------------------------------------------------------------
}
