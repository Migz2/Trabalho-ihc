import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/hive_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  try {
    await HiveService.init();
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }

  // Run the app with Riverpod
  runApp(
    const ProviderScope(
      child: HoneyApp(),
    ),
  );
}
