import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

/// Main application widget for Honey
class HoneyApp extends ConsumerWidget {
  const HoneyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'Honey',
        routerConfig: appRouter,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();

          // On wide viewports (desktop/web), simulate a mobile phone
          // viewport instead of stretching the mobile-first layout edge to
          // edge across the whole window. Overriding MediaQuery (not just
          // visually clipping) is required so width-based layout logic
          // inside the app (e.g. responsive button sizing) sees the
          // simulated 390px width instead of the real window width.
          final outerMediaQuery = MediaQuery.of(context);
          if (outerMediaQuery.size.width <= 480) {
            return child;
          }

          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Center(
              child: SizedBox(
                width: 390,
                height: outerMediaQuery.size.height,
                child: ClipRect(
                  child: MediaQuery(
                    data: outerMediaQuery.copyWith(
                      size: Size(390, outerMediaQuery.size.height),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
