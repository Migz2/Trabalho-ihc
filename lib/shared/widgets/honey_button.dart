import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';

/// Primary button component for Honey App
class HoneyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final EdgeInsets? padding;
  final ButtonVariant variant;
  final IconData? icon;
  final MainAxisAlignment mainAxisAlignment;

  const HoneyButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.padding,
    this.variant = ButtonVariant.filled,
    this.icon,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSpacing.iconMedium),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(label),
        ],
      ),
    );

    final button = switch (variant) {
      ButtonVariant.filled => _buildFilledButton(context, content),
      ButtonVariant.outlined => _buildOutlinedButton(context, content),
      ButtonVariant.text => _buildTextButton(context, content),
    };

    return width != null ? SizedBox(width: width, child: button) : button;
  }

  Widget _buildFilledButton(BuildContext context, Widget content) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: content,
    );
  }

  Widget _buildOutlinedButton(BuildContext context, Widget content) {
    return OutlinedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: content,
    );
  }

  Widget _buildTextButton(BuildContext context, Widget content) {
    return TextButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: content,
    );
  }
}

enum ButtonVariant {
  filled,
  outlined,
  text,
}
