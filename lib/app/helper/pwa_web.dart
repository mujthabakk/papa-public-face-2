import 'dart:js_interop';

@JS('__pwaCanInstall')
external bool _canInstall();

@JS('__pwaStandalone')
external bool _standalone();

@JS('__pwaInstall')
external JSPromise<JSBoolean> _install();

bool pwaCanInstall() {
  try {
    return _canInstall();
  } catch (_) {
    return false;
  }
}

bool pwaStandalone() {
  try {
    return _standalone();
  } catch (_) {
    return false;
  }
}

Future<bool> pwaInstall() async {
  try {
    final result = await _install().toDart;
    return result.toDart;
  } catch (_) {
    return false;
  }
}
