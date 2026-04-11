import 'package:service_extensions/service_extensions.dart';

void main() {
  // Register a simple 'ping' extension.
  registerServiceExtension(
    ServiceDescription(
      name: 'ext.myapp.ping',
      description: 'Check if the app is responsive.',
      returns: 'A JSON object with a status message.',
      parameters: [
        ParameterDescription(
          name: 'message',
          type: 'String',
          description: 'An optional message to echo back.',
        ),
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
      returns: 'The result of the calculation.',
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
    ),
    (parameters) async {
      final a = parameters.asIntRequired('a');
      final b = parameters.asIntRequired('b');
      final operation = parameters.asString('operation') ?? 'add';

      switch (operation) {
        case 'add':
          return a + b;
        case 'subtract':
          return a - b;
        case 'multiply':
          return a * b;
        case 'divide':
          return a / b;
        default:
          throw ArgumentError('Unknown operation: $operation');
      }
    },
  );

  print('Extensions registered. You can now use the VM service to call them.');
  print('Try calling ext.service_extensions.getExtensions to see metadata.');
}
