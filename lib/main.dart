import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/hive_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await HiveService.init();

  // Run the app wrapped in Riverpod ProviderScope
  runApp(
    const ProviderScope(
      child: HoneyApp(),
    ),
  );
}
