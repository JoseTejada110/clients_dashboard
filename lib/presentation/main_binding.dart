import 'package:get/instance_manager.dart';
import 'package:skeleton_app/data/datasource/api_repository_impl.dart';
import 'package:skeleton_app/data/datasource/local_storage_repository_impl.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocalStorageRepositoryInterface>(
      LocalStorageRepositoryImpl(),
      permanent: true,
    );
    Get.put<ApiRepositoryInteface>(
      ApiRepositoryImpl(),
      permanent: true,
    );
  }
}
