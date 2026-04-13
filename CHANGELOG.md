## 0.2.0

- **Breaking Change**: Renamed `ServiceExtensionParameters` to `ExtensionParameters`.
- **Breaking Change**: Renamed the self-discovery extension from
  `ext.service_extensions.getExtensions` to `ext.service_extensions.list`.
- **Breaking Change**: `ServiceDescription` now uses a list of
  `ReturnDescription` objects instead of a single `String? returns` field.
- **Breaking Change**: `registerServiceExtension` now requires handlers to
  return a `Map<String, Object?>`.
- Added `ReturnDescription` to provide structured metadata for service extension
  return values.
- Updated documentation and examples.

## 0.1.0

- Initial release.
- Added `ServiceDescription` and `ParameterDescription` for service extension
  metadata.
- Added `ServiceExtensionParameters` for type-safe parameter extraction.
- Added `registerServiceExtension` for easy registration and discovery.
- Added `ext.service_extensions.getExtensions` for self-discovery of registered
  extensions.
- Improved documentation and `pubspec.yaml` metadata.
