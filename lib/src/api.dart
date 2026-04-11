/// A description of a service extension.
class ServiceDescription {
  /// The name of the service extension (e.g. `ext.slipstream.ping`).
  final String name;

  /// A description of the service extension.
  final String description;

  /// A description of the return value.
  ///
  /// A null value here implies no return result / 'void'.
  final String? returns;

  /// The parameters supported by the service extension.
  final List<ParameterDescription> parameters;

  ServiceDescription({
    required this.name,
    required this.description,
    this.returns,
    this.parameters = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (returns != null) 'returns': returns,
      'parameters': parameters.map((p) => p.toJson()).toList(),
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
      'required': required,
    };
  }
}
