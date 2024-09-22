import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/header_loading_provider.dart';
import 'package:task_management/network/models/header_message_model.dart';


enum HeaderMessageStatus {
  success, warning, error;
}


Color _containerColor(HeaderMessageStatus status) {
  return switch(status) {
    HeaderMessageStatus.success => Colors.green.shade200,
    HeaderMessageStatus.error => Colors.red.shade200,
    HeaderMessageStatus.warning => Colors.yellow.shade50,

  };
}

Color _textColor(HeaderMessageStatus status) {
  return switch(status) {
    HeaderMessageStatus.success => Colors.green.shade600,
    HeaderMessageStatus.error => Colors.red.shade600,
    HeaderMessageStatus.warning => Colors.yellow.shade900,

  };
}

class HeaderMessageWidget extends StatelessWidget {

  final HeaderMessageModel headerMessage;
  const HeaderMessageWidget({required this.headerMessage, super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double headerMessageFullWidth = screenSize.width * .8;
    Color headerContainerColor = _containerColor(headerMessage.messageStatus);
    Color textColor = _textColor(headerMessage.messageStatus);
    return Container(
      width: headerMessageFullWidth,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: headerContainerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Text(headerMessage.message, style: TextStyle(color: textColor),)
        ),
      ),
    );
  }
}


class HeaderMessageWithButton extends StatelessWidget {
  final HeaderMessageModel headerMessage;
  const HeaderMessageWithButton({
    required this.headerMessage,
    super.key});



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double headerMessageFullWidth = screenSize.width * .8;
    double messageWidth = headerMessageFullWidth * .7;
    Color headerContainerColor = _containerColor(headerMessage.messageStatus);
    Color textColor = _textColor(headerMessage.messageStatus);
    return Container(
      width: screenSize.width * .8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: headerContainerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                    width: messageWidth,
                    child: Text(headerMessage.message, style: TextStyle(color: textColor),)),
              ),
              // button
              Consumer<HeaderLoadingProvider>(
                builder: (context, loadingProvider, _) {
                  if(loadingProvider.isLoading) {
                    return const SpinKitDoubleBounce(
                      color: Colors.green,
                      size: 35,
                      duration: Duration(seconds: 1),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(onPressed: headerMessage.callback, style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color?>(headerContainerColor),
                      ), child: Text(headerMessage.callbackText!, style: TextStyle(color: textColor)),
                      ),
                    );
                  }

                },

              )

            ],
          ),
        ),
      ),
    );
  }
}

