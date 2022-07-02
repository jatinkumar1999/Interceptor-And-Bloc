import 'package:flutter_practice/modal/user_modal.dart';
import 'package:flutter_practice/services/http_services/http_service.dart';

class ApiServices {
  HttpServices httpServices = HttpServices();

  Future<GetUserModal?> getUserData() async {
    GetUserModal? getUserModal;
    final response = await httpServices.getResquest(endPoint: "api/users");
    print("--->>${response?.data}");
    print("--->>${response?.statusCode}");
    if (response?.statusCode == 200) {
      getUserModal = GetUserModal.fromJson(response?.data);
      return getUserModal;
    }
  }
}
