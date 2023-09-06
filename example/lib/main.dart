import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FastCachedImageConfig.init(
    clearCacheAfter: const Duration(days: 15),
    headers: {
      // 'Accept': 'application/json; charset=UTF-8',
      // 'Content-Type': 'application/json; charset=UTF-8',
      // 'Access-Control-Allow-Credentials': 'true',
      // 'Access-Control-Allow-Origin': '*',
      // 'Access-Control-Allow-Methods': '*',
      // 'Referrer-Policy': 'no-referrer-when-downgrade',
      // 'Access-Control-Allow-Headers': 'Content-Type',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String url1 =
      'https://storage.googleapis.com/cms-storage-bucket/d83012c34a8f88a64e2b.jpg';

  bool isImageCached = false;
  String? log;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: FastCachedImage(
              url:
                  'https://skina-production.s3.eu-north-1.amazonaws.com/717/IMG-%282%29.jpg',
              fit: BoxFit.cover,
              fadeInDuration: const Duration(seconds: 1),
              errorBuilder: (context, exception, stacktrace) {
                return Text(stacktrace.toString());
              },
              loadingBuilder: (context, progress) {
                debugPrint(
                    'Progress: ${progress.isDownloading} ${progress.downloadedBytes} / ${progress.totalBytes}');
                return Container(
                  color: Colors.yellow,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (progress.isDownloading && progress.totalBytes != null)
                        Text(
                            '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                            style: const TextStyle(color: Colors.red)),
                      SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                              color: Colors.red,
                              value: progress.progressPercentage.value)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text('Is image cached? = $isImageCached',
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          Text(log ?? ''),
          const SizedBox(height: 120),
          MaterialButton(
            onPressed: () async {
              setState(() => isImageCached =
                  FastCachedImageConfig.isCached(imageUrl: url1));
            },
            child: const Text('check image is cached or not'),
          ),
          const SizedBox(height: 12),
          MaterialButton(
            onPressed: () async {
              await FastCachedImageConfig.deleteCachedImage(imageUrl: url1);
              setState(() => log = 'deleted image $url1');
              await Future.delayed(
                  const Duration(seconds: 2), () => setState(() => log = null));
            },
            child: const Text('delete cached image'),
          ),
          const SizedBox(height: 12),
          MaterialButton(
            onPressed: () async {
              await FastCachedImageConfig.clearAllCachedImages();
              setState(() => log = 'All cached images deleted');
              await Future.delayed(
                  const Duration(seconds: 2), () => setState(() => log = null));
            },
            child: const Text('delete all cached images'),
          ),
        ],
      ),
    )));
  }
}
