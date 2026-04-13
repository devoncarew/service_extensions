import 'dart:collection';
import 'dart:convert' show jsonEncode;
import 'dart:developer';

import 'api.dart';
import 'call_support.dart';

typedef ServiceHandler = Future<Map<String, Object?>> Function(
    ExtensionParameters parameters);

final List<ServiceDescription> _registeredExtensions = [];

/// Return a list of all registered service extensions.
List<ServiceDescription> get registeredExtensions =>
    UnmodifiableListView(_registeredExtensions);

/// Register a service extension.
void registerServiceExtension(
  ServiceDescription description,
  ServiceHandler handler,
) {
  // Bootstrap the discovery mechanism.
  initDiscoveryRegistry();

  _registeredExtensions.add(description);

  registerExtension(description.name, (method, parameters) async {
    try {
      final result =
          await handler(ExtensionParameters(parameters, method: method));
      return ServiceExtensionResponse.result(jsonEncode(result));
    } on ServiceExtensionResponse catch (e) {
      if (e.isError()) {
        return e;
      } else {
        rethrow;
      }
    } catch (e, st) {
      return ServiceExtensionResponse.error(
        ServiceExtensionResponse.extensionError,
        jsonEncode({
          'error': e.toString(),
          'stackTrace': st.toString(),
        }),
      );
    }
  });
}

bool _registryInitialized = false;

/// Register a service extension that returns all available service extensions
/// and their metadata.
///
/// This can safely be called multiple times.
void initDiscoveryRegistry() {
  if (_registryInitialized) return;
  _registryInitialized = true;

  registerServiceExtension(
    ServiceDescription(
      name: 'ext.service_extensions.list',
      description: 'Returns registered service extensions and their metadata.',
      returns: [
        ReturnDescription(
            name: 'extensions',
            description: 'A list of service extension descriptions.')
      ],
    ),
    (parameters) async {
      return {
        'extensions': registeredExtensions.map((e) => e.toJson()).toList()
      };
    },
  );
}
