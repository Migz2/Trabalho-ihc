import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/core/utils/animation_constants.dart';

/// onTap returns whether the action succeeded, so the button can react
/// with a success flash or an error shake without the caller managing it.
class ActionButton extends StatefulWidget {
  final String label;
  final String icon;
  final String costText;
  final Color iconBackgroundColor;
  final Future<bool> Function() onTap;

  const ActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.costText,
    required this.iconBackgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _flashSuccess = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    unawaited(HapticFeedback.lightImpact());
    final success = await widget.onTap();
    if (!mounted) return;
    if (success) {
      setState(() => _flashSuccess = true);
      Future.delayed(AnimationDurations.fast, () {
        if (mounted) setState(() => _flashSuccess = false);
      });
    } else {
      unawaited(_shakeController.forward(from: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surfaceVariant;
    final width = (MediaQuery.of(context).size.width - 48) / 3;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.93 : 1.0,
          duration: AnimationDurations.micro,
          curve: AnimationCurves.standard,
          child: Container(
            width: width,
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon in circular background
                AnimatedContainer(
                  duration: AnimationDurations.fast,
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _flashSuccess
                        ? Colors.green.withOpacity(0.35)
                        : widget.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Center(
                    child: Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Label
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                // Cost
                Text(
                  widget.costText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
