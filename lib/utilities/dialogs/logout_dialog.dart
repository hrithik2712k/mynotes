import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure youn want to delete this item',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
