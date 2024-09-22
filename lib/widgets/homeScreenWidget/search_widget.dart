import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  double parentHeight;
  double parentWidth;
  final FocusNode focusNode;
   SearchWidget({required this.parentHeight, required this.parentWidth, required this.focusNode, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: parentHeight * .8,
        // width: parentWidth * .7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 5,),
              Expanded(
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  focusNode: focusNode,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration:  InputDecoration(
                
                    hintText: 'Search',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
