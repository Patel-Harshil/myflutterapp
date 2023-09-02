import 'package:flutter/widgets.dart';
import 'package:my_flutter_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password reset",
    content:
        "We have sent you a password reset link.\n Please check your email for more information",
    optionsBuilder: () => {
      'Okay': null,
    },
  );
}
