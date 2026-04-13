import 'dart:async';
import 'package:service_extensions/service_extensions.dart';

void main() async {
  registerServiceExtension(
    ServiceDescription(
      name: 'ext.test.echo',
      description: 'Echoes the input message.',
      parameters: [
        ParameterDescription(
          name: 'message',
          type: 'String',
          description: 'The message to echo.',
          required: true,
        ),
      ],
      returns: [
        ReturnDescription(
          name: 'message',
          type: 'String',
          description: 'The echoed message.',
        ),
      ],
    ),
    (parameters) async {
      final message = parameters.asStringRequired('message');
      return {'message': message};
    },
  );

  print('Fixture app started and extension registered.');

  // Keep the app running for 30 seconds or until terminated.
  await Future.delayed(const Duration(seconds: 30));

  print('Fixture app exiting.');
}
