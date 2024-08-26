import 'package:flutter/material.dart';

class SettingsContainer extends StatefulWidget {
  final String title;
  final List<Widget> settings;
  const SettingsContainer({required this.title, required this.settings, super.key});

  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal.shade300,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(children: [Text(widget.title)],),
          ),
          SizedBox(height: 16,),
          Container(

            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.blueGrey.shade800, style: BorderStyle.solid, width: 1),
            ),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: widget.settings,
            ),
          ),
        ],
      ),
    );
  }
}
