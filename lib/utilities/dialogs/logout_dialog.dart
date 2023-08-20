import 'package:flutter/material.dart';
import 'package:my_flutter_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Lpg out",
    content: "Are you sure you want to logout?",
    optionsBuilder: () => {
      "Cancel": false,
      "Log out": true,
    },
  ).then((value) => value ?? false);
}
