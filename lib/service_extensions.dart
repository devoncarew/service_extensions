/// A package for creating type-safe and discoverable Dart VM service
/// extensions.
///
/// To use this package, call [registerServiceExtension] instead of
/// [dart:developer.registerExtension].
///
/// Use [ServiceDescription] to describe your extension and its parameters.
///
/// Inside the handler, use the [ExtensionParameters] object to extract
/// parameters in a type-safe way.
library;

export 'src/api.dart';
export 'src/call_support.dart' show ExtensionParameters;
export 'src/registery.dart' show registerServiceExtension, registeredExtensions;
