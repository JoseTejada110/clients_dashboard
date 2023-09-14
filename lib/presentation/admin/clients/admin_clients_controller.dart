import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';

class AdminClientsController extends GetxController with StateMixin {
  AdminClientsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadClients();
    super.onInit();
  }

  Future<void> loadClients() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'users',
      parser: UserModel.fromJson,
    );
    final result =
        await GeneralUsecase(apiRepository).readData<UserModel>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        users.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  RxList<UserModel> users = <UserModel>[].obs;
  final searchController = TextEditingController();
}
