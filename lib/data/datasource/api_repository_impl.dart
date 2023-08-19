import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_app/core/error_handling/exceptions.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/api_params_request.dart';

class ApiRepositoryImpl extends ApiRepositoryInteface {
  // TODO: SET URL
  static const String _baseUrl = 'http://myurl.com';

  @override
  Future<T?> executeGetRequest<T>(ApiParamsRequest params) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw NoConnectionException();
      }

      final uri = Uri.parse("$_baseUrl${params.url}");
      final response = await http.get(uri).timeout(const Duration(seconds: 40));

      if (response.statusCode == 401) {
        throw UnauthorizedException(message: jsonDecode(response.body));
      }

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } on Exception {
          throw DataParsingException();
        }
      } else {
        throw ServerException(message: jsonDecode(response.body));
      }
    } catch (e) {
      if ((e is ServerException) ||
          (e is DataParsingException) ||
          (e is NoConnectionException) ||
          (e is UnauthorizedException)) {
        rethrow;
      } else if (e is TimeoutException) {
        throw CustomTimeoutException();
      } else {
        throw UnhandledException();
      }
    }
  }

  @override
  Future<T?> executePostRequest<T>(ApiParamsRequest params) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw NoConnectionException();
      }

      final headers = {
        'Content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
      // Stopwatch stopwatch = Stopwatch()..start();

      final uri = Uri.parse("$_baseUrl${params.url}");
      final response = await http
          .post(
            uri,
            body: jsonEncode(params.body),
            headers: headers,
          )
          .timeout(const Duration(seconds: 40));
      // print('post request executed in ${stopwatch.elapsed}');

      if (response.statusCode == 401) {
        throw UnauthorizedException(message: jsonDecode(response.body));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } on Exception {
          throw DataParsingException();
        }
      } else {
        throw ServerException(message: jsonDecode(response.body));
      }
    } catch (e) {
      if ((e is ServerException) ||
          (e is DataParsingException) ||
          (e is NoConnectionException) ||
          (e is UnauthorizedException)) {
        rethrow;
      } else if (e is TimeoutException) {
        throw CustomTimeoutException();
      } else {
        throw UnhandledException();
      }
    }
  }

  @override
  Future<T?> executePutRequest<T>(ApiParamsRequest params) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw NoConnectionException();
      }

      final headers = {
        'Content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
      final uri = Uri.parse("$_baseUrl${params.url}");
      final response = await http
          .put(
            uri,
            body: jsonEncode(params.body),
            headers: headers,
          )
          .timeout(const Duration(seconds: 40));
      // print(response.body);

      if (response.statusCode == 401) {
        throw UnauthorizedException(message: jsonDecode(response.body));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } on Exception {
          throw DataParsingException();
        }
      } else {
        throw ServerException(message: jsonDecode(response.body));
      }
    } catch (e) {
      if ((e is ServerException) ||
          (e is DataParsingException) ||
          (e is NoConnectionException) ||
          (e is UnauthorizedException)) {
        rethrow;
      } else if (e is TimeoutException) {
        throw CustomTimeoutException();
      } else {
        throw UnhandledException();
      }
    }
  }

  @override
  Future<T?> executeDeleteRequest<T>(ApiParamsRequest params) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw NoConnectionException();
      }

      final uri = Uri.parse("$_baseUrl${params.url}");
      final response =
          await http.delete(uri).timeout(const Duration(seconds: 40));
      // print(response.body);

      if (response.statusCode == 401) {
        throw UnauthorizedException(message: jsonDecode(response.body));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } on Exception {
          throw DataParsingException();
        }
      } else {
        throw ServerException(message: jsonDecode(response.body));
      }
    } catch (e) {
      if ((e is ServerException) ||
          (e is DataParsingException) ||
          (e is NoConnectionException) ||
          (e is UnauthorizedException)) {
        rethrow;
      } else if (e is TimeoutException) {
        throw CustomTimeoutException();
      } else {
        throw UnhandledException();
      }
    }
  }
}
