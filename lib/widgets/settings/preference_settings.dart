import 'package:flutter/material.dart';
import 'package:task_management/widgets/settings/widgets/segment_button_widget.dart';

import '../../network/data/theme_provider.dart';
import 'package:provider/provider.dart';

Widget listTileWidget(
    {required IconData iconData,
    Widget? trailingWidget,
      required BuildContext context,
    required String title,
    required VoidCallback onTap}) {
  return ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
    leading: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(iconData)),

    title: Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium,),
      ],
    ),
    trailing: trailingWidget,
  );
}

class PreferenceSettings extends StatelessWidget {
  const PreferenceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle settingTitleStyle = Theme.of(context).textTheme.titleMedium!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [Text('Preference', style: settingTitleStyle,)],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: Colors.blueGrey.shade800,
                  style: BorderStyle.solid,
                  width: 1),
            ),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, provider, child) {
                    Set<int> selected = {provider.themeInt};
                    return SegmentButtonWidget(selected: selected, context: context);
                  },
                ),
                const Divider(),
                listTileWidget(
                  context: context,
                    iconData: Icons.notifications_outlined,
                    title: 'Push Notification',
                    onTap: () {}),
                const Divider(),
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                    leading: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        )),
                    title:  Row(
                      children: [
                        Text(
                          'Logout',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.red.shade300,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


