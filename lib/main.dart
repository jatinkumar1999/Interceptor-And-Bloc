import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/app_key/app_key.dart';
import 'package:flutter_practice/cubit/user_cubit.dart';
import 'package:flutter_practice/views/presentations/user_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: AppKey.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UserList(),
      ),
    );
  }
}
