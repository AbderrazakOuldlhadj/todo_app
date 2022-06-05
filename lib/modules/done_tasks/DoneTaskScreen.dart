import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/components/Components.dart';
import '/shared/cubit/cubit.dart';
import '/shared/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks=AppCubit.getObject(context).doneTasks;
        return BuildCondition(
          condition: tasks.length>0,
          builder: (_)=>ListView.separated(
              itemBuilder: (_,index)=>buildTaskItem(tasks[index],context,done: false),
              separatorBuilder: (_,index)=>Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: tasks.length
          ) ,
          fallback:(_)=>Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )) ,
        );
      },
    );
  }
}
