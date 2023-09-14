import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class SupportController extends GetxController {
  SupportController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  final searchController = TextEditingController();
}
