import 'package:flutter/material.dart';
import 'package:food_menu/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future<void> _showLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // User must not close the dialog manually
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: Container(
        //
        child: Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: primary, // Colors.red,
            size: 120,
          ),
        ),
      ),
    ),
  );
}

// Function to show loading dialog
Future<void> showLoadingDialog({
  required BuildContext context,
  required Future Function() f1,
}) async {
  // Show the loading dialog
  _showLoading(context);
  // Wait for the Future to complete
  var sw = Stopwatch()..start();
  print("starting f1");
  await f1();
  print("end f1");
  print(sw.elapsedMilliseconds / 1000.0);

  // Dismiss the loading dialog
  Navigator.of(context).pop();
}
