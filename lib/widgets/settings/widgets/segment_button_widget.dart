import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../network/data/theme_provider.dart';

class SegmentButtonWidget extends StatelessWidget {
  const SegmentButtonWidget({
    super.key,
    required this.selected,
    required this.context,
  });

  final Set<int> selected;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const <ButtonSegment<int>>[
        ButtonSegment(
          value: 0,
          label: Text('Light'),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Dark'),
        ),
        ButtonSegment(
          value: 2,
          label: Text('System'),
        ),
      ],
      selected: selected,

      onSelectionChanged: (newSelection) {
        context
            .read<ThemeProvider>()
            .editThemeMode(newSelection.first);
      },
      style:  ButtonStyle(

        textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          return const TextStyle(fontSize: 16);
        }),
        padding: WidgetStateProperty.resolveWith<EdgeInsets>((state) {
          return const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);


        }),
        backgroundColor:WidgetStateProperty.resolveWith<Color>((states) {
          if(states.contains(WidgetState.selected)) {
            return Colors.tealAccent;
          }
          return Theme.of(context).colorScheme.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if(states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return Theme.of(context).colorScheme.onSurface;
        }),

      ),
    );
  }
}