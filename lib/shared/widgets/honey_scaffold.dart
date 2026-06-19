import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';

/// Base scaffold wrapper for Honey App screens
class HoneyScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottomNavigationBar;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  const HoneyScaffold({
    Key? key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showBackButton = false,
    this.actions,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title != null || showBackButton || actions != null
          ? AppBar(
            title: title != null ? Text(title!) : null,
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.pop(),
            )
                : null,
            actions: actions,
          )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
