import 'package:flutter/material.dart';

/// Renders a circular avatar whose icon and tint reflect the user's selected
/// gender ('Male' / 'Female'), so profile pictures across the app always
/// match the profile instead of a fixed placeholder photo.
class GenderAvatar extends StatelessWidget {
  final String gender;
  final double radius;

  const GenderAvatar({super.key, required this.gender, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final isFemale = gender.toLowerCase() == 'female';
    final color = isFemale ? Colors.pinkAccent : Colors.blueAccent;

    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(
        isFemale ? Icons.female_rounded : Icons.male_rounded,
        size: radius * 1.3,
        color: color,
      ),
    );
  }
}
