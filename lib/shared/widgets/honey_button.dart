import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

/// Primary button widget for Honey app
class HoneyButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isPressed = onPressed != null && isEnabled && !isLoading;

    Widget child = _buildContent();

    if (variant == ButtonVariant.filled) {
      return SizedBox(
        width: width,
        height: height,
        child: FilledButton(
          onPressed: isPressed ? onPressed : null,
          child: child,
        ),
      );
    } else if (variant == ButtonVariant.outlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isPressed ? onPressed : null,
          child: child,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: isPressed ? onPressed : null,
          child: child,
        ),
      );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.filled
                ? Colors.white
                : Theme.of(
                    // ignore: invalid_use_of_protected_member
                    _scaffoldMessengerKey.currentContext!)
                  .primaryColor,
          ),
        ),
      );
    }

    if (isIconOnly && icon != null) {
      return Icon(icon);
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}

enum ButtonVariant { filled, outlined, text }

// Workaround for getting context in _buildContent
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
