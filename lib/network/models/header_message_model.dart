import 'package:flutter/material.dart';
import 'package:task_management/widgets/homeScreenWidget/header_message_widget.dart';

class HeaderMessageModel {
  String message;
  HeaderMessageStatus messageStatus;
  VoidCallback? callback;
  String? callbackText;

  HeaderMessageModel({
    required this.message,
    required this.messageStatus,
    this.callback,
    this.callbackText,

});
}