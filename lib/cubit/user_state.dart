// ignore_for_file: must_be_immutable

part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  List<Data>? data;
  final Data? detail;
  UserState({
    this.data,
    this.detail,
  });

  @override
  List<Object?> get props => [data, detail];
}

class LoadingState extends UserState {}

class GetUserData extends UserState {
  List<Data>? data;

  GetUserData({this.data});
}

class GetUserDetail extends UserState {
  final Data? detail;

  GetUserDetail({this.detail});
}

class Load extends UserState {}
