import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Disk cache on iOS/Android/desktop. Web uses the browser HTTP cache
/// (path_provider is not available in Chrome).
class MediaCache {
  static const key = 'papabear_media';

  static CacheManager? get manager {
    if (kIsWeb) return null;
    return _native;
  }

  static final CacheManager _native = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  static CachedNetworkImageProvider provider(String url) {
    final cache = manager;
    if (cache == null) return CachedNetworkImageProvider(url);
    return CachedNetworkImageProvider(url, cacheManager: cache);
  }
}
