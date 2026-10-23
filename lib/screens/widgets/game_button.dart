import 'package:flutter/material.dart';

// Reusable button widget
class GameButton extends StatelessWidget {
  final String text; // Text displayed
  final VoidCallback? onPressed; // Function called on button press
  final double? width;
  final double height;
  final double fontSize;
  final GameButtonVariant variant; // Determine visual style

  // Constructor
  const GameButton({
    super.key,
    required this.text, // Button must have text
    required this.onPressed, // Required argument; null disables button
    // Optional customization with default values where specified
    this.width,
    this.height = 50,
    this.fontSize = 16,
    this.variant = GameButtonVariant.primary,
  });

  @override // Method override
  Widget build(BuildContext context) {
    // Retrieve the app's color scheme
    final colors = Theme.of(context).colorScheme;

    // Determines which color scheme to use
    // Replace with a switch if more variants are added
    final isPrimary = variant == GameButtonVariant.primary;

    return SizedBox(
      // SizedBox controls dimensions
      width: width,
      height: height,
      // Actual button
      child: ElevatedButton(
        onPressed: onPressed,
        // Control button appearance
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary // Fill color
              ? colors.primary
              : colors.secondaryContainer,
          foregroundColor:
              isPrimary // Text color
              ? colors.onPrimary
              : colors.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Widget inside elevated button
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// Different visual styles
enum GameButtonVariant { primary, secondary }