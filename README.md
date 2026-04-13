# service_extensions

A package for creating type-safe and discoverable Dart VM service extensions.

## Why use this package?

Standard Dart VM service extensions have a few limitations:

- **Parameters are untyped**: All parameters are passed as `String`s in a `Map<String, String>`.
- **Discovery is limited**: While the VM service can list available extensions, it doesn't provide any information about their parameters, return types, or purpose.

The `service_extensions` package addresses these issues by:

- Providing a **type-safe API** for extracting parameters from service extension calls.
- Adding a **discovery mechanism** to query metadata about all registered extensions.
- Simplifing extension registration with automatic error handling and JSON encoding.

## Features

- **Type-safe Parameter Extraction**: Easily parse `int`, `bool`, `double`, and `String` parameters, with built-in validation and clear error messages for missing or malformed values.
- **Service Registry**: Automatically tracks all registered extensions and their descriptions.
- **Self-discovery**: Exposes a `ext.service_extensions.list` extension that returns metadata for all extensions registered through this package.
- **Unified Error Handling**: Automatically catches exceptions and returns them as properly formatted `ServiceExtensionResponse` errors.

## Usage

### Registering an Extension

To register an extension, use `registerServiceExtension` and provide a `ServiceDescription`:

```dart
import 'package:service_extensions/service_extensions.dart';

void main() {
  registerServiceExtension(
    ServiceDescription(
        name: 'ext.myapp.ping',
        description: 'Check if the app is responsive.',
        parameters: [
          ParameterDescription(
            name: 'message',
            type: 'String',
            description: 'An optional message to echo back.',
            required: false,
          ),
        ],
        returns: [
          ReturnDescription(
            name: 'status',
            type: 'String',
            description: 'The status message.',
          )
        ]),
    (parameters) async {
      final message = parameters.asString('message') ?? 'pong';
      return {'status': 'ok', 'message': message};
    },
  );
}
```

### Type-safe Parameters

Use the `ServiceExtensionParameters` object to safely extract parameters:

```dart
(parameters) async {
  // Required parameters will throw a ServiceExtensionResponse.error if missing.
  int count = parameters.asIntRequired('count');

  // Optional parameters return null if not provided.
  bool? verbose = parameters.asBool('verbose');

  // Parameters that fail to parse will also throw an error back to the client.
  double threshold = parameters.asDoubleRequired('threshold');

  return {'count': count, 'verbose': verbose, 'threshold': threshold};
}
```

### Discovery

Once you've registered at least one extension using this package, you can call
`ext.service_extensions.list` via the VM service protocol to get a list
of all registered extensions and their metadata.

Example response:

```json
[
  {
    "name": "ext.service_extensions.list",
    "description": "Returns all available service extensions and their metadata.",
    "parameters": [],
    "returns": [
      {
        "name": "extensions",
        "description": "A list of service extension descriptions."
      }
    ]
  },
  {
    "name": "ext.myapp.ping",
    "description": "Check if the app is responsive.",
    "parameters": [
      {
        "name": "message",
        "type": "String",
        "description": "An optional message to echo back.",
        "required": false
      }
    ],
    "returns": [
      {
        "name": "status",
        "description": "The status message."
      }
    ]
  }
]
```
