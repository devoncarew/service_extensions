import 'dart:developer' as dev;

import 'package:service_extensions/service_extensions.dart';
import 'package:service_extensions/src/registry.dart'
    show initDiscoveryRegistry;
import 'package:test/test.dart';

void main() {
  group('ServiceExtensionParameters', () {
    test('asString', () {
      final params = ServiceExtensionParameters({'foo': 'bar'}, method: 'test');
      expect(params.asString('foo'), 'bar');
      expect(params.asString('baz'), isNull);
    });

    test('asStringRequired', () {
      final params = ServiceExtensionParameters({'foo': 'bar'}, method: 'test');
      expect(params.asStringRequired('foo'), 'bar');
      expect(() => params.asStringRequired('baz'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });

    test('asBool', () {
      final params = ServiceExtensionParameters({'foo': 'true', 'bar': 'false'},
          method: 'test');
      expect(params.asBool('foo'), isTrue);
      expect(params.asBool('bar'), isFalse);
      expect(params.asBool('baz'), isNull);

      final badParams =
          ServiceExtensionParameters({'foo': 'not-a-bool'}, method: 'test');
      expect(() => badParams.asBool('foo'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });

    test('asBoolRequired', () {
      final params =
          ServiceExtensionParameters({'foo': 'true'}, method: 'test');
      expect(params.asBoolRequired('foo'), isTrue);
      expect(() => params.asBoolRequired('baz'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });

    test('asInt', () {
      final params = ServiceExtensionParameters({'foo': '123'}, method: 'test');
      expect(params.asInt('foo'), 123);
      expect(params.asInt('bar'), isNull);

      final badParams =
          ServiceExtensionParameters({'foo': 'abc'}, method: 'test');
      expect(() => badParams.asInt('foo'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });

    test('asIntRequired', () {
      final params = ServiceExtensionParameters({'foo': '123'}, method: 'test');
      expect(params.asIntRequired('foo'), 123);
      expect(() => params.asIntRequired('bar'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });

    test('asDouble', () {
      final params =
          ServiceExtensionParameters({'foo': '123.45'}, method: 'test');
      expect(params.asDouble('foo'), 123.45);
      expect(params.asDouble('bar'), isNull);

      final badParams =
          ServiceExtensionParameters({'foo': 'abc'}, method: 'test');
      expect(() => badParams.asDouble('foo'),
          throwsA(isA<dev.ServiceExtensionResponse>()));
    });
  });

  group('ServiceDescription', () {
    test('tracking registered extensions', () {
      initDiscoveryRegistry();

      final listExtensions = registeredExtensions
          .firstWhere((e) => e.name == 'ext.service_extensions.getExtensions');
      expect(listExtensions.description, contains('metadata'));

      // Check toJson output
      final json = listExtensions.toJson();
      expect(json['name'], 'ext.service_extensions.getExtensions');
      expect(json['description'], contains('metadata'));
    });

    test('ParameterDescription.toJson', () {
      final param = ParameterDescription(
        name: 'foo',
        type: 'String',
        description: 'a bar',
        required: true,
      );
      final json = param.toJson();
      expect(json['name'], 'foo');
      expect(json['type'], 'String');
      expect(json['description'], 'a bar');
      expect(json['required'], isTrue);
    });
  });
}
