import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/user_cubit.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //---

                state.detail?.avatar != null
                    ? Hero(
                        tag: "${state.detail?.id}",
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(state.detail?.avatar ?? ""),
                        ),
                      )
                    : const SizedBox(),
                //------
                const SizedBox(
                  height: 15,
                ),
                //-----
                Text("${state.detail?.firstName} ${state.detail?.lastName}"),

                //-----
                const SizedBox(
                  height: 10,
                ),
                //----
                Text("${state.detail?.email} "),
                //-----
              ],
            ),
          );
        },
      ),
    );
  }
}
