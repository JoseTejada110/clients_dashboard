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
  List<Filter>? whereParams;
  final FirebaseOrderByParam? orderBy;
  final Parser? parser;
}

class FirebaseOrderByParam {
  FirebaseOrderByParam(this.field, {this.descending = false});
  final String field;
  final bool descending;
}
