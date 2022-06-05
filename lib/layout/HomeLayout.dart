import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:buildcondition/buildcondition.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

// 1.create database
// 2.create tables
// 3.open database
// 4.insert to database
// 5.get from database
// 6.update database
// 7.delete from database

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext ctx) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext ctx, AppStates state) {
          if (state is AppInsertToDatabaseState) Navigator.pop(ctx);
        },
        builder: (BuildContext ctx, AppStates state) {
          AppCubit cubit = AppCubit.getObject(ctx);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("${cubit.titles[cubit.currentIndex]} Task"),
            ),
            body: BuildCondition(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (_) => cubit.screens[cubit.currentIndex],
              fallback: (_) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if ((formKey.currentState as FormState).validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    /*insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      ).then((value) {
                        Navigator.pop(context);
                        isBottomSheetShown = false;
                        titleController.clear();
                        timeController.clear();
                        dateController.clear();
                        */ /*setState(() {
                        fabIcon = Icons.edit;
                      });*/ /*
                      });*/
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Task title",
                                    prefixIcon: Icon(Icons.title),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    print('title tapped');
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'title must not be empty !';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Task time",
                                    prefixIcon:
                                        Icon(Icons.watch_later_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  controller: timeController,
                                  //keyboardType: TextInputType.text,
                                  onTap: () {
                                    print('time tapped');
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    )
                                        .then((value) => timeController.text =
                                            value!.format(context).toString())
                                        .catchError((er) {});
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'time must not be empty !';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Task Date",
                                    prefixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  //enabled: false,
                                  controller: dateController,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2100-12-31"),
                                      initialDate: DateTime.now(),
                                    ).then((value) => dateController.text =
                                        DateFormat.yMMMd().format(value!));
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'date must not be empty !';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((_) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
            /*CurvedNavigationBar(
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              items: [
                Column(
                  children: [
                    Icon(Icons.menu,color: Colors.white,),
                    Text("Tasks"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.check_circle_outline,color: Colors.white,),
                    Text("Done"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.archive_outlined,color: Colors.white,),
                    //Text("Archived"),
                  ],
                ),
              ],
              onTap: (index) {
                cubit.changeIndex(index);
              },

            ),*/
          );
        },
      ),
    );
  }
}
