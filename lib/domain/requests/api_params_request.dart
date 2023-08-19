typedef Parser<T> = T Function(dynamic data);

class ApiParamsRequest {
  ApiParamsRequest({
    required this.url,
    this.body,
    this.addConnectionToBody = true,
  });
  final String url;
  final Map<String, dynamic>? body;

  /// Este booleano se utiliza para identificar cuando se debe agregar los campos de la conexión al body de la petición
  final bool addConnectionToBody;
}
