import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class CustomerHomeController extends GetxController {
  CustomerHomeController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;
}