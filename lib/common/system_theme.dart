import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemTheme extends StatefulWidget {
  final Widget child;
  const SystemTheme({required this.child, super.key});

  @override
  State<SystemTheme> createState() => _SystemThemeState();
}

class _SystemThemeState extends State<SystemTheme> with WidgetsBindingObserver{


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    updateSystemUiOverlay();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangePlatformBrightness() {

    super.didChangePlatformBrightness();
    updateSystemUiOverlay();
  }

  void updateSystemUiOverlay() {
    final Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

      statusBarColor: brightness == Brightness.dark ? const Color(0xFF2f3136) : const Color(0xFFe9ecef),
      statusBarBrightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemStatusBarContrastEnforced: true,

    ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
