import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/modules/todo_app/cubit/cubit.dart';
import 'package:todoapp/modules/todo_app/cubit/states.dart';
import 'package:todoapp/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  // void initState() {
  //   super.initState();

  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.curruntIndex]),
              backgroundColor: Colors.deepPurple[300],
            ),
            body: cubit.screens[cubit.curruntIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbottomSheetShow) {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: cubit.titleController.text,
                        time: cubit.timeController.text,
                        date: cubit.dateController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDataFromDataBase(database).then((value) {
                    //     Navigator.pop(context);

                    //     // setState(() {
                    //     //   isbottomSheetShow = false;
                    //     //   fabIcon = Icons.edit;

                    //     //   tasks = value;
                    //     //   print(value);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  cubit.scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: cubit.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFromField(
                                  controller: cubit.titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "title must not be empty";
                                    }
                                    return null;
                                  },
                                  label: "Task Title",
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFromField(
                                  controller: cubit.timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubit.timeController.text =
                                          value!.format(context).toString();
                                      // print(value.format(context));
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "time must not be empty";
                                    }
                                    return null;
                                  },
                                  label: "Task Time",
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFromField(
                                  controller: cubit.dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-01-01'),
                                    ).then((value) {
                                      cubit.dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "date must not be empty";
                                    }
                                    return null;
                                  },
                                  label: "Task Date",
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 50,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });

                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.curruntIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
          );
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return "Ahemd Ali";
  // }

// Get a location using getDatabasesPath
}
