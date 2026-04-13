import 'dart:io';

import 'package:vm_service/vm_service_io.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart tool/list_extensions.dart <vm-service-uri>');
    exit(1);
  }

  final uri = Uri.parse(args[0]).replace(scheme: 'ws');
  final vmService = await vmServiceConnectUri(uri.toString());

  final vm = await vmService.getVM();
  final mainIsolate = vm.isolates!.first;

  // TODO: determine if our extensions always have to return maps
  // TODO: is this a VM requirement? a limitation of the protocol package?
  // a good convention?

  try {
    final response = await vmService.callServiceExtension(
        'ext.service_extensions.list',
        isolateId: mainIsolate.id);
    var extensions = response.json!['extensions'] as List?;

    if (extensions == null) {
      print('No extensions found or unexpected response format.');
      print('Response: ${response.json}');
      exit(1);
    }

    for (final ext in extensions) {
      final name = ext['name'];
      final description = ext['description'];
      final params = (ext['parameters'] as List?) ?? [];
      final returns = (ext['returns'] as List?) ?? [];

      print('## `$name`');
      print('');
      print(description);
      print('');
      if (params.isNotEmpty) {
        print('| Parameter | Description |');
        print('| --- | --- |');
        for (final param in params.cast<Map<String, Object?>>()) {
          // name, desc, type, required
          final name = param['name'] as String;
          final description = param['description'] as String;
          final type = param['type'] as String;
          final required = param['required'] as bool? ?? false;
          final requiredDesc = required ? '(required) ' : '';

          print('| $type `$name` | $requiredDesc$description |');
        }
        print('');
      }
      if (returns.isNotEmpty) {
        print('| Returns | Description |');
        print('| --- | --- |');
        for (final ret in returns.cast<Map<String, Object?>>()) {
          final name = ret['name'] as String;
          final description = ret['description'] as String;
          final type = ret['type'] as String?;
          final typeDesc = type == null ? '' : ': $type';

          print("| `'$name'`$typeDesc | $description |");
        }
        print('');
      }
    }
  } finally {
    await vmService.dispose();
  }
}
