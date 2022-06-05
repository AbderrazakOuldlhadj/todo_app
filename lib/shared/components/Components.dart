import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/shared/cubit/cubit.dart';

Widget buildTaskItem(Map task, context,
        {bool archive = true, bool done = true}) =>
    Slidable(
      actionPane: SlidableBehindActionPane(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(task['time']),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: task['status'] == 'done'
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      task['date'],
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionExtentRatio: 0.5,
      actions: [
        IconSlideAction(
          color: Colors.red,
          caption: "Delete",
          icon: Icons.delete,
          onTap: () {
            AppCubit.getObject(context).deleteDatabase(id: task['id']);
          },
        ),
      ],
      secondaryActions: [
        if (archive)
          IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () {
              AppCubit.getObject(context)
                  .updateData(status: 'archive', id: task['id']);
            },
          ),
        if (done)
          IconSlideAction(
            caption: 'Done',
            color: Colors.greenAccent,
            icon: Icons.check_box,
            onTap: () {
              AppCubit.getObject(context)
                  .updateData(status: 'done', id: task['id']);
            },
          )
      ],
    );
