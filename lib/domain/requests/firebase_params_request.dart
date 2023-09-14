import 'package:cloud_firestore/cloud_firestore.dart';

typedef Parser<T> = T Function(Map<String, dynamic> data);

class ApiParamsRequest {
  ApiParamsRequest({required this.url, this.body});
  final String url;
  final Map<String, dynamic>? body;
}

class FirebaseParamsRequest {
  FirebaseParamsRequest({
    this.collection = '',
    this.documentReference,
    this.data,
    this.whereParams,
    this.orderBy,
    this.parser,
  });
  final String collection;
  final DocumentReference<Map<String, dynamic>>? documentReference;
  final Map<String, dynamic>? data;
  final List<FirebaseWhereParams>? whereParams;
  final FirebaseOrderByParam? orderBy;
  final Parser? parser;
}

/// Clase utilizada para enviar los distintos filtros a la consulta de firestore
class FirebaseWhereParams {
  FirebaseWhereParams(
    this.field, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
  final String field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final Iterable<Object?>? arrayContainsAny;
  final Iterable<Object?>? whereIn;
  final Iterable<Object?>? whereNotIn;
  final bool? isNull;
}

class FirebaseOrderByParam {
  FirebaseOrderByParam(this.field, {this.descending = false});
  final String field;
  final bool descending;
}
