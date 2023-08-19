import 'package:skeleton_app/domain/requests/api_params_request.dart';

abstract class ApiRepositoryInteface {
  Future<T?> executeGetRequest<T>(ApiParamsRequest params);
  Future<T?> executePostRequest<T>(ApiParamsRequest params);
  Future<T?> executePutRequest<T>(ApiParamsRequest params);
  Future<T?> executeDeleteRequest<T>(ApiParamsRequest params);
}
