// To run this example, use `dart run --observe example/main.dart`.

import 'package:service_extensions/service_extensions.dart';

void main() {
  // Register a simple 'ping' extension.
  registerServiceExtension(
    ServiceDescription(
      name: 'ext.myapp.ping',
      description: 'Check if the app is responsive.',
      parameters: [
        ParameterDescription(
          name: 'message',
          type: 'String',
          description: 'An optional message to echo back.',
        ),
      ],
      returns: [
        ReturnDescription(
            name: 'status',
            type: 'String',
            description: 'The returned message.')
      ],
    ),
    (parameters) async {
      final message = parameters.asString('message') ?? 'pong';
      return {'status': 'ok', 'message': message};
    },
  );

  // Register an extension that demonstrates type-safe parameter extraction.
  registerServiceExtension(
    ServiceDescription(
      name: 'ext.myapp.calculate',
      description: 'Perform a simple calculation.',
      parameters: [
        ParameterDescription(
          name: 'a',
          type: 'int',
          description: 'The first number.',
          required: true,
        ),
        ParameterDescription(
          name: 'b',
          type: 'int',
          description: 'The second number.',
          required: true,
        ),
        ParameterDescription(
          name: 'operation',
          type: 'String',
          description:
              'The operation to perform (add, subtract, multiply, divide); '
              'defaults to add.',
        ),
      ],
      returns: [
        ReturnDescription(
            name: 'result',
            type: 'int',
            description: 'The result of the calculation.')
      ],
    ),
    (parameters) async {
      final a = parameters.asIntRequired('a');
      final b = parameters.asIntRequired('b');
      final operation = parameters.asString('operation') ?? 'add';

      int result = switch (operation) {
        'add' => a + b,
        'subtract' => a - b,
        'multiply' => a * b,
        'divide' => (a / b).round(),
        _ => throw ArgumentError('Unknown operation: $operation')
      };

      return {'result': result};
    },
  );

  print('Extensions registered!');
  print('You can now use the VM service to call them.');
  print('');
  print('Try calling ext.service_extensions.list to see metadata.');
}
