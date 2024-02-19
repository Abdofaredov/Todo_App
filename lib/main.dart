import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/layout/todo_app/todo_layout.dart';
import 'package:todoapp/modules/todo_app/cubit/cubit.dart';
import 'package:todoapp/modules/todo_app/cubit/states.dart';
import 'package:todoapp/shared/bloc_observer.dart';
import 'package:todoapp/shared/styles/themes.dart';

void main() async {
  // بيتأكد من كل حاجه هنا في المثيود خلصت وبعدين يفتح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: const HomeLayout(),
          );
        },
      ),
    );
  }
}
