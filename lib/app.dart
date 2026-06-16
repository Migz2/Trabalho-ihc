import 'package:flutter/material.dart';
import 'shared/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

/// Main application widget for Honey
class HoneyApp extends StatelessWidget {
  const HoneyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Honey',
      routerConfig: appRouter,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
