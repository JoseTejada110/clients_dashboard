import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';

class ProfileController extends GetxController {
  ProfileController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;
}
