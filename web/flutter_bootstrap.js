{{flutter_js}}
{{flutter_build_config}}

var isSafari = navigator.vendor === 'Apple Computer, Inc.';
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
    canvasKitVariant: 'full',
  },
  // Safari + GitHub Pages service workers often freeze on a grey screen.
  serviceWorkerSettings: isSafari
      ? undefined
      : { serviceWorkerVersion: {{flutter_service_worker_version}} },
});
