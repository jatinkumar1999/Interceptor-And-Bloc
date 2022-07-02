import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_practice/modal/user_modal.dart';
import 'package:flutter_practice/services/api_service/api_services.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(LoadingState());
  ApiServices services = ApiServices();
  GetUserModal? getUserModal;

  tapped() async {
    emit(Load());
    await Future.delayed(const Duration(seconds: 2), () {
      emit(GetUserData(
        data: getUserModal?.data,
      ));
    });
  }

  getUserData() async {
    emit(LoadingState());
    getUserModal = await services.getUserData();

    emit(GetUserData(
      data: getUserModal?.data,
    ));
  }

  getUserDataBack() async {
    emit(GetUserData(
      data: getUserModal?.data,
    ));
  }

  getUserDetail({required Data? detail}) {
    emit(LoadingState());

    emit(GetUserDetail(
      detail: detail,
    ));
  }
}
