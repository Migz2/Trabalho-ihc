import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../navigation/app_routes.dart';

/// Home shell with bottom navigation bar
/// Wraps all main app screens (Focus, Pet, History, Settings)
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
  late String _selectedRoute;

  @override
  void initState() {
    super.initState();
    _selectedRoute = AppRoutes.focus;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedRoute();
  }

  void _updateSelectedRoute() {
    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.focus) {
      _selectedRoute = AppRoutes.focus;
    } else if (location == AppRoutes.pet) {
      _selectedRoute = AppRoutes.pet;
    } else if (location == AppRoutes.history) {
      _selectedRoute = AppRoutes.history;
    } else if (location == AppRoutes.settings) {
      _selectedRoute = AppRoutes.settings;
    }
  }

  void _navigateTo(String route) {
    setState(() {
      _selectedRoute = route;
    });
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.timer_outlined,
                activeIcon: Icons.timer,
                label: 'Foco',
                route: AppRoutes.focus,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.pets_outlined,
                activeIcon: Icons.pets,
                label: 'Pet',
                route: AppRoutes.pet,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: 'Histórico',
                route: AppRoutes.history,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Ajustes',
                route: AppRoutes.settings,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required BuildContext context,
  }) {
    final isActive = _selectedRoute == route;
    final color = isActive
        ? context.primaryColor
        : context.textSecondaryColor;

    return GestureDetector(
      onTap: () => _navigateTo(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
