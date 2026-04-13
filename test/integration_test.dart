import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

void main() {
  late Process process;
  late VmService service;

  tearDown(() async {
    process.kill();
    await process.exitCode;
  });

  test('Integration: list extensions and call echo', () async {
    // Start the fixture app with a debug port.
    process = await Process.start(
      Platform.executable,
      ['--observe=0', '--no-pause-isolates-on-start', 'test/fixture_app.dart'],
    );

    // Capture the VM Service URI from stdout.
    final completer = Completer<Uri>();
    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      if (line.contains('The Dart VM service is listening on')) {
        final uriString = line.split(' ').last;
        completer.complete(Uri.parse(uriString));
      }
    });

    final uri = await completer.future.timeout(const Duration(seconds: 10));
    final wsUri = uri.replace(scheme: 'ws', path: '${uri.path}ws');

    await Future.delayed(Duration(milliseconds: 250));

    // Connect to the VM service.
    service = await vmServiceConnectUri(wsUri.toString());

    // Wait for the isolate to be runnable.
    final vm = await service.getVM();
    final isolateId = vm.isolates!.first.id!;

    // 1. Test listing extensions.
    final listResponse = await service.callServiceExtension(
      'ext.service_extensions.list',
      isolateId: isolateId,
    );

    final extensions = listResponse.json!['extensions'] as List;
    expect(
      extensions,
      contains(
        containsPair('name', 'ext.test.echo'),
      ),
    );
    expect(
      extensions,
      contains(
        containsPair('name', 'ext.service_extensions.list'),
      ),
    );

    // 2. Test calling the registered extension.
    final echoResponse = await service.callServiceExtension(
      'ext.test.echo',
      isolateId: isolateId,
      args: {'message': 'hello world'},
    );

    expect(echoResponse.json!['message'], 'hello world');

    await service.dispose();
  });
}
