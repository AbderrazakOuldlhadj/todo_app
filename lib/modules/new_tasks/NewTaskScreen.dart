import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/components/Components.dart';
import '/shared/cubit/cubit.dart';
import '/shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.getObject(context).newTasks;
        return BuildCondition(
          condition: tasks.length>0,
          builder: (_)=>ListView.separated(
              itemBuilder: (_, index) => Row(
                children: [
                  Expanded(child: buildTaskItem(tasks[index],context)),
                  /*SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        AppCubit.getObject(context)
                            .updateData(status: 'done', id: tasks[index]['id']);
                      },
                      icon: Icon(Icons.check_box,
                          color: Theme.of(context).primaryColor),
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.getObject(context).updateData(
                            status: 'archive', id: tasks[index]['id']);
                      },
                      icon: Icon(Icons.archive, color: Colors.black45),
                    ),*/
                ],
              ),
              separatorBuilder: (_, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: tasks.length),
          fallback: (_)=>Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
        );
      },
    );
  }
}
