import 'package:flutter/material.dart';

class ThemedIcon extends StatelessWidget {
  final IconData iconData;
  const ThemedIcon(this.iconData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
