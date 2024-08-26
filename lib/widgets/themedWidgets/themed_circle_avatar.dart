import 'package:flutter/material.dart';

class ThemedCircleAvatar extends StatelessWidget {
  final double radius;
  final Widget child;
  const ThemedCircleAvatar({required this.radius, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      radius: radius,
      child: child,
    );
  }
}
