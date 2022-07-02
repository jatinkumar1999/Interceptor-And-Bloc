import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/user_cubit.dart';
import 'package:flutter_practice/views/presentations/user_detail_screen.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isTapped = false;
  UserCubit? userBloc;
  final bucketKey = PageStorageBucket();

  // StreamSubscription<ConnectivityResult>? _networkSubscription;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserCubit>(context);
    userBloc?.getUserData();

    // _networkSubscription =
    //     Connectivity().onConnectivityChanged.listen((connectionResult) {
    //   if (connectionResult == ConnectivityResult.mobile ||
    //       connectionResult == ConnectivityResult.wifi) {
    //     userBloc?.getUserData();
    //   } else if (connectionResult == ConnectivityResult.none) {
    //     _networkSubscription?.cancel();
    //   }
    // });
  }

  @override
  void dispose() {
    // _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      // bloc: userBloc,
      listener: (context, state) {
        if (state is GetUserDetail) {
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UserDetailScreen()))
              .then((value) {
            BlocProvider.of<UserCubit>(context).getUserDataBack();
          });
        }
      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Users List"),
          ),
          body: PageStorage(
            bucket: bucketKey,
            child: ListView.builder(
                key: const PageStorageKey<String>("pageStorageKey"),
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                itemCount: userBloc?.getUserModal?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<UserCubit>(context)
                          .getUserDetail(detail: state.data?[index]);
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading:
                            userBloc?.getUserModal?.data?[index].avatar != null
                                ? Hero(
                                    tag:
                                        "${userBloc?.getUserModal?.data?[index].id}",
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "${userBloc?.getUserModal?.data?[index].avatar}"),
                                    ),
                                  )
                                : const SizedBox(),
                        title: Text(
                            userBloc?.getUserModal?.data?[index].firstName ??
                                ""),
                        subtitle: Text(
                            userBloc?.getUserModal?.data?[index].email ?? ""),
                      ),
                    ),
                  );
                }),
          ),
          // body: Center(
          //   child: (state is Load)
          //       ? const Center(
          //           child: CircularProgressIndicator(),
          //         )
          //       : ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             onPrimary: Colors.blue,
          //             primary: Colors.white,
          //           ),
          //           onPressed: () {
          //             BlocProvider.of<UserCubit>(context).tapped();
          //           },
          //           child: const Text("Tap")),
          // ),
        );
      },
    );
  }
}
