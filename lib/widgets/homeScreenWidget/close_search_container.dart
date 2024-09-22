import 'package:flutter/material.dart';

class CloseSearchContainer extends StatelessWidget {
   const CloseSearchContainer({required this.notifier, required this.searchFocusNode, super.key});
   final ValueNotifier<bool> notifier;
   final FocusNode searchFocusNode;
  final double size = 45;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        notifier.value = false;
        searchFocusNode.unfocus();
      },
      child: Container(
        width: size,
        height: size,
        decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)

        ),
        child: const Icon(Icons.close, size: 30,),
      ),
    );
  }
}
