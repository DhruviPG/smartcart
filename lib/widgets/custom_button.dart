import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
        Text(label),
      ],
    );

    return isOutlined
        ? OutlinedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: content,
          )
        : ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: content,
          );
  }
}
