import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class AdminTransactionsController extends GetxController {
  AdminTransactionsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;
  final TextEditingController searchController = TextEditingController();
}
