import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/animation_constants.dart';

enum ButtonVariant { filled, outlined, text }

/// Primary button widget for Honey app.
/// Adds a tap-scale + haptic micro-interaction on top of the base button.
class HoneyButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isIconOnly;

  const HoneyButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 48,
    this.padding,
    this.variant = ButtonVariant.filled,
    this.icon,
    this.isIconOnly = false,
  }) : super(key: key);

  @override
  State<HoneyButton> createState() => _HoneyButtonState();
}

class _HoneyButtonState extends State<HoneyButton> {
  bool _pressed = false;

  bool get _isActive =>
      widget.onPressed != null && widget.isEnabled && !widget.isLoading;

  void _setPressed(bool pressed) {
    if (!_isActive) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);

    Widget button;
    switch (widget.variant) {
      case ButtonVariant.filled:
        button = FilledButton(
          onPressed: _isActive ? widget.onPressed : null,
          child: child,
        );
        break;
      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: _isActive ? widget.onPressed : null,
          child: child,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: _isActive ? widget.onPressed : null,
          child: child,
        );
        break;
    }

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        if (_isActive) HapticFeedback.lightImpact();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AnimationDurations.micro,
        curve: AnimationCurves.standard,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: button,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.isLoading) {
      final spinnerColor = widget.variant == ButtonVariant.filled
          ? Colors.white
          : Theme.of(context).colorScheme.primary;
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        ),
      );
    }

    if (widget.isIconOnly && widget.icon != null) {
      return Icon(widget.icon);
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon),
          const SizedBox(width: AppSpacing.sm),
          Text(widget.label),
        ],
      );
    }

    return Text(widget.label);
  }
}
