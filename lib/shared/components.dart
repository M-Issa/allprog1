import 'package:allprog1/shared/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() function,
  required String text,
  bool isUpperCase = true,
  double radius = 0,
}) =>
    Container(
      width: width,
      height: 40.0,
      color: background,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );
//////////////////////////////////////////////////////////////////
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  String Function(String)? onSubmit,
  String Function(String)? onChange,
  void Function()? onTap,
  required FormFieldValidator? validate,//Bard
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isPassword=false,
}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );


Widget buildTaskItem(Map model,context){
  return Dismissible(key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(
            width: 24,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey,),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24,
          ),
          IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDatabase(status: 'done', id: model['id'],);
            },
            icon: Icon(Icons.check_box,color:Colors.purple),
          ),
          IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDatabase(
                  status: 'archived', id: model['id']);
            },
            icon: Icon(Icons.archive,color: Colors.pinkAccent,),
          ),
        ],
      ),
    ),
    onDismissed: (direction)
    {
      AppCubit.get(context).deleteDatabase(id:model['id'],);
    },
  );
}


Widget tasksBuilder({
  required List<Map> tasks,
})=>ConditionalBuilder(
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context),//List<Map> tasks
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey,
      ),
    ),
    itemCount: tasks.length,//tasks from consts.dart
  ),
  condition:tasks.length>0,
  fallback: (context) =>const Center(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size:100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet,Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

      ],
    ),
  ),
);