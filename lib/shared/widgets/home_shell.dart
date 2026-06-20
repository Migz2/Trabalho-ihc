import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/focus/presentation/providers/timer_provider.dart';
import '../../features/focus/presentation/widgets/stop_session_dialog.dart';
import '../../features/statistics/presentation/providers/statistics_provider.dart';
import '../../features/statistics/presentation/widgets/achievement_unlock_overlay.dart';
import '../navigation/app_routes.dart';

/// Shell widget with bottom navigation bar for Honey app
class HomeShell extends ConsumerStatefulWidget {
  final Widget child;

  const HomeShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = _getSelectedIndex();
  }

  int _getSelectedIndex() {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.focus)) return 0;
    if (location.startsWith(AppRoutes.pet)) return 1;
    if (location.startsWith(AppRoutes.shop)) return 2;
    if (location.startsWith(AppRoutes.history)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  Future<void> _onNavigationTapped(int index) async {
    if (index == _selectedIndex) return;

    final timer = ref.read(timerProvider).value;
    if (timer != null && (timer.isRunning || timer.isPaused)) {
      final confirmed = await showStopConfirmationDialog(
        context,
        remainingSeconds: timer.remainingSeconds,
        currentCycle: timer.currentCycle,
        totalCycles: timer.totalCycles,
      );
      if (!confirmed) return;
      ref.read(timerProvider.notifier).reset();
    }

    if (!mounted) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go(AppRoutes.focus);
        break;
      case 1:
        context.go(AppRoutes.pet);
        break;
      case 2:
        context.go(AppRoutes.shop);
        break;
      case 3:
        context.go(AppRoutes.history);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    ref.listen(newlyUnlockedAchievementsProvider, (previous, next) async {
      if (next.isEmpty) return;
      for (final achievement in next) {
        if (!context.mounted) return;
        AchievementUnlockOverlay.show(context, achievement);
        await Future.delayed(const Duration(milliseconds: 600));
      }
      ref.read(newlyUnlockedAchievementsProvider.notifier).state = [];
    });

    final surfaceColor = isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
    final dividerColor = isDarkMode ? AppColors.darkDivider : AppColors.lightDivider;
    final accentColor = isDarkMode ? AppColors.darkAccent : AppColors.lightAccent;
    final textSecondary =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: widget.child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: dividerColor, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onNavigationTapped,
          backgroundColor: surfaceColor,
          indicatorColor: accentColor.withOpacity(0.15),
          elevation: 0,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _buildDestination(
              icon: Icons.schedule_rounded,
              label: 'Foco',
              selectedColor: accentColor,
              unselectedColor: textSecondary,
            ),
            _buildDestination(
              icon: Icons.pets_rounded,
              label: 'Pet',
              selectedColor: accentColor,
              unselectedColor: textSecondary,
            ),
            _buildDestination(
              icon: Icons.shopping_cart_rounded,
              label: 'Loja',
              selectedColor: accentColor,
              unselectedColor: textSecondary,
            ),
            _buildDestination(
              icon: Icons.history_rounded,
              label: 'Histórico',
              selectedColor: accentColor,
              unselectedColor: textSecondary,
            ),
            _buildDestination(
              icon: Icons.settings_rounded,
              label: 'Ajustes',
              selectedColor: accentColor,
              unselectedColor: textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildDestination({
    required IconData icon,
    required String label,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return NavigationDestination(
      icon: Icon(icon, size: 24, color: unselectedColor),
      selectedIcon: Icon(icon, size: 24, color: selectedColor),
      label: label,
    );
  }
}
