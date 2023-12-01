import 'package:allprog1/shared/components.dart';
import 'package:allprog1/shared/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/consts.dart';
import '../shared/states.dart';

class ArchivedScreen extends StatelessWidget {
  //List<Map> tasks=[];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks=AppCubit.get(context).archivedTasks;
        return tasksBuilder(tasks: tasks);
      },
    );

  }
}
