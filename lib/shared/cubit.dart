import 'package:allprog1/shared/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../layouts/archived.dart';
import '../layouts/done.dart';
import '../layouts/tasks.dart';
import 'consts.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialStates());

  static AppCubit get(context)=>BlocProvider.of(context);

  var currentIndex = 0;
  Database? database;

  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];



  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<String> title = [
    'tasks',
    'done',
    'archived',
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeNavBarState());
  }
  void creatDatabase() {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) {
          print(
            'database created...',
          );
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)')
              .then((value) {
            print(
              'table created ',
            );
          }).catchError(
                (error) {
              print('Error when creating table');
            },
          );
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened' '');
        }).then((value)
     {
       database=value;
       emit(AppCreateDatabaseState());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database?.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted sucessfuly');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error while inserting some record ${error.toString()}');
      });
      return Future.value(1);
    });
  }

  void getDataFromDatabase(database) async
   {
     newTasks=[];
     doneTasks=[];
     archivedTasks=[];

    emit(AppGetDatabaseLoadingState());
     database!.rawQuery('SELECT * FROM tasks').then((value){

       emit(AppGetDatabaseState());
       value.forEach((element){
         if (element['status']=='new')
           newTasks.add(element);
         else if (element['status']=='done')
           doneTasks.add(element);
         else
           archivedTasks.add(element);
       });
     });

  }


  void updateDatabase({
    required String status,
    required int id,
}) async
   {
      database!.rawUpdate(
         'UPDATE tasks SET status = ?  WHERE id = ?',
         ['$status', id,]).then((value)
      {
        getDataFromDatabase(database);
        emit(AppUpdateDatabaseState());
      });
   }



   void deleteDatabase({
    required int id,
})
   {
     database?.rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value)
     {
       getDataFromDatabase(database);
       emit(AppDeleteFromDatabaseState());
     });
   }
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}