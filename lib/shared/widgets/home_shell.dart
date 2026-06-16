import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../navigation/app_routes.dart';

/// Shell widget with bottom navigation bar for Honey app
class HomeShell extends StatefulWidget {
  final Widget child;

  const HomeShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _getSelectedIndex();
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

  void _onNavigationTapped(int index) {
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

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavigationTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
          selectedItemColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
          unselectedItemColor: isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          selectedLabelStyle: Theme.of(context).textTheme.labelSmall,
          unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
          elevation: 0,
          items: [
            _buildNavItem(
              icon: Icons.schedule_rounded,
              label: 'Foco',
              isSelected: _selectedIndex == 0,
              theme: theme,
            ),
            _buildNavItem(
              icon: Icons.pets_rounded,
              label: 'Pet',
              isSelected: _selectedIndex == 1,
              theme: theme,
            ),
            _buildNavItem(
              icon: Icons.shopping_cart_rounded,
              label: 'Loja',
              isSelected: _selectedIndex == 2,
              theme: theme,
            ),
            _buildNavItem(
              icon: Icons.history_rounded,
              label: 'Histórico',
              isSelected: _selectedIndex == 3,
              theme: theme,
            ),
            _buildNavItem(
              icon: Icons.settings_rounded,
              label: 'Ajustes',
              isSelected: _selectedIndex == 4,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required ThemeData theme,
  }) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? Icon(icon, size: 28)
          : Icon(icon, size: 24),
      activeIcon: Icon(icon, size: 28),
      label: label,
    );
  }
}
