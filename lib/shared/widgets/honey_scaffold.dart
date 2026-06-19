import 'package:flutter/material.dart';

/// Base scaffold widget for Honey app
/// Handles AppBar, bottom nav, and standard layout
class HoneyScaffold extends StatelessWidget {
  final Widget body;
  final String? appBarTitle;
  final List<Widget>? appBarActions;
  final bool showAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BottomNavigationBarItem? navigationItem;
  final int currentIndex;
  final ValueChanged<int>? onNavigationChanged;
  final List<BottomNavigationBarItem>? navigationItems;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final EdgeInsetsGeometry bodyPadding;
  final bool safeArea;

  const HoneyScaffold({
    Key? key,
    required this.body,
    this.appBarTitle,
    this.appBarActions,
    this.showAppBar = true,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationItem,
    this.currentIndex = 0,
    this.onNavigationChanged,
    this.navigationItems,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.bodyPadding = EdgeInsets.zero,
    this.safeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = body;

    if (bodyPadding != EdgeInsets.zero) {
      content = Padding(
        padding: bodyPadding,
        child: content,
      );
    }

    if (safeArea) {
      content = SafeArea(
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      appBar: appBar ??
          (showAppBar
              ? AppBar(
                  title: appBarTitle != null ? Text(appBarTitle!) : null,
                  actions: appBarActions,
                  elevation: 0,
                )
              : null),
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
