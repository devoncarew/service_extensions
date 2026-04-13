/// A description of a service extension.
class ServiceDescription {
  /// The name of the service extension (e.g. `ext.slipstream.ping`).
  final String name;

  /// A description of the service extension.
  final String description;

  /// The parameters supported by the service extension.
  final List<ParameterDescription> parameters;

  /// Descriptions of the fields in the Map return value.
  ///
  /// An empty list here implies no return result / 'void'.
  final List<ReturnDescription> returns;

  ServiceDescription({
    required this.name,
    required this.description,
    this.parameters = const [],
    this.returns = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (parameters.isNotEmpty)
        'parameters': parameters.map((p) => p.toJson()).toList(),
      if (returns.isNotEmpty)
        'returns': returns.map((p) => p.toJson()).toList(),
    };
  }
}

/// A description of a service extension parameter.
class ParameterDescription {
  /// The name of the parameter.
  final String name;

  /// The type of the parameter (e.g. `String`, `int`, `bool`).
  final String type;

  /// A description of the parameter.
  final String description;

  /// Whether the parameter is required.
  final bool required;

  ParameterDescription({
    required this.name,
    required this.type,
    required this.description,
    this.required = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      if (required) 'required': required,
    };
  }
}

class ReturnDescription {
  /// The name of the return value - the field in the returned map.
  final String name;

  /// A description of the return value.
  final String description;

  /// The optional type of the return value.
  ///
  /// Populate this if the return value maps to a simple type (e.g. `String`,
  /// `int`, `bool`).
  final String? type;

  ReturnDescription({required this.name, required this.description, this.type});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (type != null) 'type': type,
    };
  }
}
