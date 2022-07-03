import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/user_cubit.dart';
import 'package:flutter_practice/modal/user_modal.dart';
import 'package:flutter_practice/views/presentations/user_detail_screen.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isTapped = false;
  bool isSearch = false;
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
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchField(
                        searchList: userBloc?.getUserModal?.data,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search)),
            ],
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

class SearchField extends SearchDelegate {
  List<Data>? searchList;
  List<Data>? filterList = [];
  SearchField({
    this.searchList,
  });
  @override
  set query(String value) {
    // TODO: implement query
    super.query = value;
    print("sdgsdg===>${super.query}");
    print("sdgsdg===>$value");
    print("sdgsdg===>$searchList");
  }

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => "Search user name ...";
  @override
  // TODO: implement searchFieldDecorationTheme
  InputDecorationTheme? get searchFieldDecorationTheme =>
      const InputDecorationTheme(
        fillColor: Colors.red,
        border: InputBorder.none,
        isCollapsed: true,
      );

  @override
  // TODO: implement query
  String get query => super.query;

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();

    return [
      IconButton(
        color: Colors.black,
        onPressed: () {
          if (query.isEmpty || query == "") {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.cancel),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      color: Colors.black,
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  @override
  Widget buildResults(BuildContext context) {
    searchList?.forEach((name) {
      if (query.isNotEmpty) {
        if (name.firstName!.toLowerCase().contains(query.toLowerCase())) {
          filterList = [];
          filterList?.add(name);
          print("length==>>${name.toJson()}");
          print("length==>>${filterList?.length}");
        }
      } else {
        filterList = searchList;
        print("filterList==>>${filterList?.length}");
      }
    });

    return ListView.builder(
        itemCount: filterList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: filterList?[index].avatar != null
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage("${filterList?[index].avatar}"),
                  )
                : const SizedBox(),
            // title: Text("${filterList?[index].firstName}"),
            title: RichText(
              text: TextSpan(
                children: highlightOccurrences(
                    "${filterList?[index].firstName}", query),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            subtitle: Text("${filterList?[index].email}"),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return ListView.builder(
        itemCount: filterList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: filterList?[index].avatar != null
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage("${filterList?[index].avatar}"),
                  )
                : const SizedBox(),
            // title: Text("${filterList?[index].firstName}"),
            title: RichText(
              text: TextSpan(
                children: highlightOccurrences(
                    "${filterList?[index].firstName}", query),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            subtitle: Text("${filterList?[index].email}"),
          );
        });
  }
}
